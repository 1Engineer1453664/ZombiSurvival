-- Подключаем серверную часть ядра гейммода Zombie Survival
INC_SERVER()

-- Локальная функция для сброса владельца поля, если игрок отключился или зашел за зомби
local function RefreshRepFieldOwners(pl)
    -- Запускаем цикл, который ищет все энтити ремонтных полей на карте
    for _, ent in pairs(ents.FindByClass("prop_repairfield*")) do
        -- Если поле валидно и его создателем является нужный нам игрок
        if ent:IsValid() and ent:GetObjectOwner() == pl then
            -- Принудительно очищаем владельца, делая поле "ничейным"
            ent:ClearObjectOwner()
        end
    end
end
-- Привязываем функцию к игровому событию (хуку) отключения игрока от сервера
hook.Add("PlayerDisconnected", "RepairField.PlayerDisconnected", RefreshRepFieldOwners)
-- Привязываем функцию к хуку изменения команды игрока (например, если он стал зомби)
hook.Add("OnPlayerChangedTeam", "RepairField.OnPlayerChangedTeam", RefreshRepFieldOwners)

-- Функция инициализации энтити (вызывается один раз в момент спавна коробки на земле)
function ENT:Initialize()
    -- Устанавливаем трехмерную модель вышки для объекта
    self:SetModel("models/props/de_nuke/smokestack01.mdl")
    -- Уменьшаем масштаб модели до 55% (визуальный размер)
    self:SetModelScale(0.40, 0)
    -- Создаем физический хитбокс в форме коробки по заданным координатам-векторам
    self:PhysicsInitBox(Vector(-12.29, -12.29, 0), Vector(12.29, 12.29, 90.13))
    -- Задаем границы столкновений (коллизии), чтобы пули и игроки регистрировали объект
    self:SetCollisionBounds(Vector(-12.29, -12.29, 0), Vector(12.29, 12.29, 90.13))
    -- Переводим объект в группу коллизий WORLD, чтобы пропы не застревали друг в друге
    self:SetCollisionGroup(COLLISION_GROUP_WORLD)
    -- Устанавливаем тип использования "SIMPLE_USE" (срабатывает сразу при однократном нажатии 'E')
    self:SetUseType(SIMPLE_USE)

    -- Обновляем внутренние правила коллизий для движка Source
    self:CollisionRulesChanged()

    -- Получаем физический объект нашей энтити для работы с его физикой
    local phys = self:GetPhysicsObject()
    -- Проверяем, существует ли физический объект (удалось ли его инициализировать)
    if phys:IsValid() then
        -- Назначаем объекту материал "металл" (влияет на искры и звуки ударов)
        phys:SetMaterial("metal")
        -- Полностью отключаем движение объекта, чтобы он намертво застыл в воздухе/на земле
        phys:EnableMotion(false)
        -- Активируем (будим) физику объекта для применения всех параметров
        phys:Wake()
    end

    -- Устанавливаем максимальный запас здоровья ремонтной коробки равным 150 ед.
    self:SetMaxObjectHealth(150)
    -- Заполняем текущее здоровье коробки до её максимального значения
    self:SetObjectHealth(self:GetMaxObjectHealth())
end

-- Функция изменения здоровья коробки (отвечает также за её уничтожение)
function ENT:SetObjectHealth(health)
    -- Записываем текущее здоровье в сетевую переменную (DT Float под индексом 1) для вывода на экран
    self:SetDTFloat(1, health)
    -- Если здоровье упало до 0 или ниже, и объект еще не помечен как уничтоженный
    if health <= 0 and not self.Destroyed then
        -- Ставим флаг, что коробка полностью уничтожена
        self.Destroyed = true

        -- Проверяем, жив ли еще владелец коробки и находится ли он в команде людей
        if self:GetObjectOwner():IsValidLivingHuman() then
            -- Отправляем владельцу системное уведомление на экран о том, что его поле уничтожено
            self:GetObjectOwner():SendDeployableLostMessage(self)
        end

        -- Создаем временный физический проп на месте коробки, чтобы красиво симулировать её разрушение
        local ent = ents.Create("prop_physics")
        -- Если временный проп успешно создался
        if ent:IsValid() then
            -- Копируем в него модель нашего ремонтного поля
            ent:SetModel(self:GetModel())
            -- Копируем материал (текстуру)
            ent:SetMaterial(self:GetMaterial())
            -- Копируем угол наклона в пространстве
            ent:SetAngles(self:GetAngles())
            -- Копируем точную позицию на карте
            ent:SetPos(self:GetPos())
            -- Копируем скин (внешний вид) или ставим 0 по умолчанию
            ent:SetSkin(self:GetSkin() or 0)
            -- Копируем цвет объекта
            ent:SetColor(self:GetColor())
            -- Рождаем временный проп в игровом мире
            ent:Spawn()
            -- Посылаем пропу команду моментально сломаться (рассыпаться на обломки)
            ent:Fire("break", "", 0)
            -- Полностью удаляем остатки логики пропа через 0.1 секунды, чтобы не забивать сервер
            ent:Fire("kill", "", 0.1)
        end

        -- Находим точные координаты центра нашей коробки в мировом пространстве
        local pos = self:LocalToWorld(self:OBBCenter())

        -- Создаем стандартный визуальный эффект взрыва Source
        local effectdata = EffectData()
            -- Задаем точку, где произойдет взрыв
            effectdata:SetOrigin(pos)
        -- Запускаем эффект взрыва в мир
        util.Effect("Explosion", effectdata, true, true)

        -- Рассчитываем количество патронов, которое выпадет на землю (половина от того, что оставалось внутри)
        local amount = math.ceil(self:GetAmmo() * 0.5)
        -- Запускаем цикл спавна пачек патронов, пока не выбросим всю рассчитанную сумму
        while amount > 0 do
            -- Ограничиваем максимальный размер одной пачки патронов в 50 единиц
            local todrop = math.min(amount, 50)
            -- Вычитаем этот объем из общей суммы выпадения
            amount = amount - todrop
            -- Создаем на сервере энтити подбираемых патронов
            ent = ents.Create("prop_ammo")
            -- Если энтити патронов успешно создана
            if ent:IsValid() then
                -- Генерируем случайное направление (вектор) для разлета пачки
                local heading = VectorRand():GetNormalized()
                -- Задаем тип патронов — импульсные патроны ("pulse")
                ent:SetAmmoType("pulse")
                -- Закладываем количество патронов в пачку
                ent:SetAmmo(todrop)
                -- Ставим пачку чуть в стороне от центра взрыва, используя случайный вектор
                ent:SetPos(pos + heading * 8)
                -- Придаем пачке патронов случайный угол вращения
                ent:SetAngles(VectorRand():Angle())
                -- Спавним пачку патронов в мире
                ent:Spawn()

                -- Получаем физический объект созданной пачки патронов
                local phys = ent:GetPhysicsObject()
                -- If физика пачки валидна
                if phys:IsValid() then
                    -- Толкаем пачку взрывной силой в случайном направлении, чтобы она красиво отлетела
                    phys:ApplyForceOffset(heading * math.Rand(8000, 32000), pos)
                end
            end
        end
    end
end

-- Функция вызывается автоматически каждый раз, когда коробка получает любой урон
function ENT:OnTakeDamage(dmginfo)
    -- Если входящий урон равен нулю или отрицательный — полностью игнорируем его
    if dmginfo:GetDamage() <= 0 then return end

    -- Передаем урон физическому движку для просчета флинча/импульса
    self:TakePhysicsDamage(dmginfo)

    -- Получаем того, кто нанес урон полю (игрока или зомби)
    local attacker = dmginfo:GetAttacker()
    -- Если атакующий объект НЕ является живым игроком-человеком (то есть это урон от зомби)
    if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
        -- Отнимаем полученный урон из текущего запаса здоровья нашей коробки
        self:SetObjectHealth(self:GetObjectHealth() - dmginfo:GetDamage())
        -- Записываем этого зомби в память коробки как последнего атаковавшего (нужно для логов)
        self:ResetLastBarricadeAttacker(attacker, dmginfo)
    end
end

-- Функция взаимодействия (вызывается, когда игрок подходит к коробке и нажимает кнопку 'E')
function ENT:Use(activator, caller)
    -- Защита: если поле удаляется, кнопку нажал не игрок или поле невидимо (замаскировано) — выходим
    if self.Removing or not activator:IsPlayer() or self:GetMaterial() ~= "" then return end

    -- Если кнопку взаимодействия нажал выживший человек
    if activator:Team() == TEAM_HUMAN then
        -- Если у этого ремонтного поля уже установлен законный владелец
        if self:GetObjectOwner():IsValid() then
            -- Если у игрока в консоли/настройках НЕ включена опция "запретить заправку построек по кнопке E"
            if activator:GetInfo("zs_nousetodeposit") == "0" then
                -- Получаем текущее количество патронов внутри коробки
                local curammo = self:GetAmmo()
                -- Считаем сколько патронов (макс. 15 шт за раз) можно забрать у игрока и влить в лимит коробки
                local togive = math.min(math.min(15, activator:GetAmmoCount("pulse")), self.MaxAmmo - curammo)
                -- Если мы можем передать хотя бы 1 патрон
                if togive > 0 then
                    -- Добавляем патроны в бак коробки
                    self:SetAmmo(curammo + togive)
                    -- Отрезаем это же количество патронов из инвентаря игрока
                    activator:RemoveAmmo(togive, "pulse")
                    -- Воспроизводим анимацию жеста "передача/протягивание предмета" от первого лица
                    activator:RestartGesture(ACT_GMOD_GESTURE_ITEM_GIVE)
                    -- Воспроизводим характерный пищащий звук сканирования/заправки
                    self:EmitSound("npc/scanner/combat_scan1.wav", 60, 250)
                end
            end
        else
            -- Если поле было бесхозным (например, старый хозяин умер), то сделавший клик становится новым хозяином
            self:SetObjectOwner(activator)
            -- Отправляем новому хозяину сообщение по центру экрана: "Вы заявили права на постройку"
            self:GetObjectOwner():SendDeployableClaimedMessage(self)
        end
    end
end

-- Функция вызывается, когда игрок нажимает комбинацию Alt + E возле коробки
function ENT:AltUse(activator, tr)
    -- Запускаем встроенный процесс сворачивания (упаковки) объекта обратно в инвентарь
    self:PackUp(activator)
end

-- Внутренний хук, срабатывающий сразу после того, как упаковка завершилась успешно
function ENT:OnPackedUp(pl)
    -- Выдаем игроку обратно пустой пульт-сваппер этого ремонтного поля
    pl:GiveEmptyWeapon(self.SWEP)
    -- Возвращаем 1 единицу боеприпаса самого предмета (чтобы его можно было снова поставить)
    pl:GiveAmmo(1, self.DeployableAmmo)

    -- Сохраняем текущее здоровье коробки в массив упакованных вещей игрока (чтобы вернуть его при спавне)
    pl:PushPackedItem(self:GetClass(), self:GetObjectHealth())
    -- Возвращаем абсолютно все патроны из бака коробки обратно игроку в виде патронов "pulse"
    pl:GiveAmmo(self:GetAmmo(), "pulse")

    -- Полностью и бесследно удаляем энтити коробки с игровой карты
    self:Remove()
end

-- ГЛАВНАЯ ФУНКЦИЯ: Мыслительный цикл ремонтного поля (расчет импульсов починки)
function ENT:Think()
    -- Защита: если поле разрушено, моментально вырезаем его энтити и прекращаем любой код
    if self.Destroyed then
        self:Remove()
        return
    end

    -- Главный фильтр тиков поля. Завершаем выполнение функции, если:
    -- 1) Время следующего импульса еще не настало (CurTime() меньше таймера)
    -- 2) Внутри коробки полностью кончились патроны (self:GetAmmo() <= 0)
    -- 3) Владелец поля мертв или вышел с сервера
    if CurTime() < self:GetNextRepairPulse() or self:GetAmmo() <= 0 or not self:GetObjectOwner():IsValidLivingHuman() then return end

    -- Вычисляем мировую точку старта импульса (смещаем её на 30 юнитов вверх от пола внутри коробки)
    local pos = self:LocalToWorld(Vector(0, 0, 30))
    -- Создаем счетчик починенных за один импульс объектов (сбрасывается в 0 при каждом тике)
    local count = 0
    -- Создаем короткую ссылку на владельца ремонтного поля для оптимизации кода
    local owner = self:GetObjectOwner()

    -- Умножаем это значение на модификаторы скорости ремонта от личных перков игрока (RepairRateMul)
    local totalheal = (self.HealValue or 10) * (owner.RepairRateMul or 1)

    -- НАШЕ ИЗМЕНЕНИЕ (РАСЧЁТ СКОРОСТИ/ЗАДЕРЖКИ ИМПУЛЬСОВ):
    -- Создаем переменную базовой задержки и по умолчанию приравниваем её к твоей 1 секунде
    local baseDelay = 1.0

    if self.HealValue and self.HealValue > 10 then
        -- Если значение дошло до 6.5 (это максимальный 3-й уровень прокачки пушки)
        if self.HealValue >= 16.0 then
            -- Ставим максимальную скорость — задержка между тиками снижается до 0.65 секунды
            baseDelay = 0.65
        -- Если значение промежуточное (5.75, то есть 2-й уровень прокачки пушки)
        else
            -- Ставим среднюю скорость — задержка между тиками будет 0.82 секунды
            baseDelay = 0.82
        end
    end

    -- ЦИКЛ СКАНИРОВАНИЯ: Находим все энтити в сфере вокруг нашей позиции (pos) в радиусе действия поля (MaxDistance)
    for _, hitent in pairs(ents.FindInSphere(pos, self.MaxDistance * (owner.FieldRangeMul or 1))) do
        -- Отсеиваем цели: если объект невалиден, если это само поле, или если объект закрыт от поля стеной карты
        if not hitent:IsValid() or hitent == self or not WorldVisible(pos, hitent:NearestPoint(pos)) then
            -- Пропускаем этот объект и переходим к следующему в цикле
            continue
        end

        -- Сбрасываем флаг успешного лечения для текущего проверяемого объекта
        local healed = false

        -- ПРОВЕРКА ТИПА 1: Если найденный объект — это укрепленная баррикада на гвоздях
        if hitent:IsNailed() then
            -- Запоминаем текущее здоровье этой баррикады
            local oldhealth = hitent:GetBarricadeHealth()
            -- Если баррикада уже сломана в ноль, починена на максимум, или у неё кончился "лимит гвоздей на ремонт" — пропускаем
            if oldhealth <= 0 or oldhealth >= hitent:GetMaxBarricadeHealth() or hitent:GetBarricadeRepairs() <= 0.01 then continue end

            -- Рассчитываем и выставляем новое здоровье баррикаде: добавляем totalheal, но не выше лимита ремонта и лимита ХП баррикады
            hitent:SetBarricadeHealth(math.min(hitent:GetMaxBarricadeHealth(), hitent:GetBarricadeHealth() + math.min(hitent:GetBarricadeRepairs(), totalheal)))
            -- Вычисляем чистую разницу: сколько единиц здоровья баррикада фактически получила в этот тик
            healed = hitent:GetBarricadeHealth() - oldhealth
            -- Списываем ровно столько же единиц с доступного "лимита гвоздей для ремонта" на этой баррикаде
            hitent:SetBarricadeRepairs(math.max(hitent:GetBarricadeRepairs() - healed, 0))

        -- ПРОВЕРКА ТИПА 2: Если найденный объект — инженерный механизм (турель, раздатчик, патронная коробка)
        elseif hitent.GetObjectHealth then
            -- Если турель прямо сейчас чинит инженер своим гаечным ключом — поле уступает ему и не тратит патроны
            if hitent.HitByWrench and hitent:HitByWrench(self, owner, nil) then continue end

            -- Запоминаем текущее здоровье механизма/турели
            local oldhealth = hitent:GetObjectHealth()
            -- Если турель уничтожена, полностью цела, или получала урон в последние 4 секунды — пропускаем её
            if oldhealth <= 0 or oldhealth >= hitent:GetMaxObjectHealth() or hitent.m_LastDamaged and CurTime() < hitent.m_LastDamaged + 4 then continue end

            -- Лечим турель. В гейммоде ZS ради баланса автоматическое поле лечит механизмы в 2 раза слабее, чем баррикады (totalheal / 2)
            hitent:SetObjectHealth(math.min(hitent:GetMaxObjectHealth(), hitent:GetObjectHealth() + totalheal / 2))
            -- Вычисляем точное количество здоровья, которое восстановила турель
            healed = hitent:GetObjectHealth() - oldhealth
        end

        -- ЕСЛИ КТО-ТО ИЗ ОБЪЕКТОВ БЫЛ УСПЕШНО ПОЧИНЕН В ТЕКУЩЕМ ЦИКЛЕ
        if healed then
            -- НАШЕ ИЗМЕНЕНИЕ: Если поле на макс. прокачке (задержка 0.65), делаем звук сервопривода выше и технологичнее (115)
            local pitch = (baseDelay == 0.65) and 115 or math.random(100, 105)
            -- Воспроизводим случайный механический звук работы сервоприводов с рассчитанной высотой тона (pitch)
            hitent:EmitSound("npc/dog/dog_servo"..math.random(7, 8)..".wav", 70, pitch)
            -- Вызываем системный хук гейммода Zombie Survival, чтобы выдать инженеру очки/деньги за ремонт баррикады
            gamemode.Call("PlayerRepairedObject", owner, hitent, healed, self)

            -- Создаем структуру данных для генерации эффекта зеленых искр починки
            local effectdata = EffectData()
                -- Указываем позицию, где появится эффект (на пропе)
                effectdata:SetOrigin(hitent:GetPos())
                -- Рассчитываем нормаль (направление вектора эффекта от коробки к пропу)
                effectdata:SetNormal((self:GetPos() - hitent:GetPos()):GetNormalized())
                -- Выставляем масштаб/силу эффекта равным 1
                effectdata:SetMagnitude(1)
            -- Пускаем визуальный эффект "nailrepaired" на экраны всех игроков в зоне видимости
            util.Effect("nailrepaired", effectdata, true, true)

            -- Забираем ровно 1 патрон из бака нашего ремонтного поля
            self:SetAmmo(self:GetAmmo() - 1)

            -- Увеличиваем счетчик успешно починенных предметов на +1
            count = count + 1

            -- ОГРАНИЧЕНИЕ: За один импульс поле может полечить не больше 3 пропов. Если лимит достигнут или сели патроны — прерываем поиск
            if count >= 3 or self:GetAmmo() <= 0 then break end
        end
    end

    -- НАШЕ ИЗМЕНЕНИЕ (ОБНОВЛЕНИЕ ТАЙМЕРА СЛЕДУЮЩЕГО ТИКА):
    -- Если поле за этот тик починило хотя бы одну вещь (count больше нуля)
    if count > 0 then
        -- Высчитываем время следующей пульсации: берем наше динамическое время (1.0, 0.82 или 0.65) и умножаем на перк задержки поля инженера (FieldDelayMul)
        self:SetNextRepairPulse(CurTime() + baseDelay * (owner.FieldDelayMul or 1))
    else
        -- Если чинить было нечего, поле просто засыпает ровно на время baseDelay секунд до следующей проверки пространства
        self:SetNextRepairPulse(CurTime() + baseDelay)
    end

    -- Принудительно передаем движку Garry's Mod точное время, когда нужно снова разбудить функцию ENT:Think()
    self:NextThink(self:GetNextRepairPulse())
    -- Возвращаем true, чтобы подтвердить успешное завершение мыслительного кадра энтити
    return true
end
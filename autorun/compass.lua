log.info("[compass.lua] loaded")

local cfg = json.load_file("compass.json")

if not cfg then
  cfg = {
    font_size = imgui.get_default_font_size() - 2,
    font_name = "Tahoma",
    position = 240,
    width = 500,
    cardinal_height = 28,
    cardinal_thickness = 3,
    aux_height = 18,
    aux_thickness = 2,
    aux_count = 3,
    fov = 180,
    main_line_color = 0xffffffff,
    cardinal_color = 0xffffffff,
    aux_color = 0xffffffff,
    icon_size = 40,
    icon_below = false,
    icon_line_height = 4,
    icon_line_thickness = 2,
    icon_line_color = 0xffffff7f,
    reticle_enabled = true,
    reticle_size = 8,
    reticle_thickness = 1,
    reticle_color = 0xffffff7f,
  }
end

re.on_config_save(
  function()
    json.dump_file("compass.json", cfg)
  end
)

local monster_list = {
  ["Rathian"] = true,
  ["Rathalos"] = true,
  ["Khezu"] = true,
  ["Basarios"] = true,
  ["Diablos"] = true,
  ["Daimyo Hermitaur"] = true,
  ["Shogun Ceanataur"] = true,
  ["Rajang"] = true,
  ["Kushala Daora"] = true,
  ["Chameleos"] = true,
  ["Teostra"] = true,
  ["Tigrex"] = true,
  ["Nargacuga"] = true,
  ["Barioth"] = true,
  ["Barroth"] = true,
  ["Royal Ludroth"] = true,
  ["Great Baggi"] = true,
  ["Zinogre"] = true,
  ["Great Wroggi"] = true,
  ["Arzuros"] = true,
  ["Lagombi"] = true,
  ["Volvidon"] = true,
  ["Gore Magala"] = true,
  ["Shagaru Magala"] = true,
  ["Seregios"] = true,
  ["Astalos"] = true,
  ["Mizutsune"] = true,
  ["Magnamalo"] = true,
  ["Bishaten"] = true,
  ["Aknosom"] = true,
  ["Tetranadon"] = true,
  ["Somnacanth"] = true,
  ["Rakna-Kadaki"] = true,
  ["Almudron"] = true,
  ["Wind Serpent Ibushi"] = true,
  ["Goss Harag"] = true,
  ["Great Izuchi"] = true,
  ["Thunder Serpent Narwa"] = true,
  ["Anjanath"] = true,
  ["Pukei-Pukei"] = true,
  ["Kulu-Ya-Ku"] = true,
  ["Jyuratodus"] = true,
  ["Tobi-Kadachi"] = true,
  ["Bazelgeuse"] = true,
  ["Malzeno"] = true,
  ["Lunagaron"] = true,
  ["Garangolm"] = true,
  ["Gaismagorm"] = true,
  ["Espinas"] = true,
  ["Blood Orange Bishaten"] = true,
  ["Aurora Somnacanth"] = true,
  ["Pyre Rakna-Kadaki"] = true,
  ["Magma Almudron"] = true,
  ["Furious Rajang"] = true,
  ["Crimson Glow Valstrax"] = true,
  ["Scorned Magnamalo"] = true,
  ["Narwa the Allmother"] = true,
  ["Apex Rathian"] = true,
  ["Apex Rathalos"] = true,
  ["Apex Diablos"] = true,
  ["Apex Zinogre"] = true,
  ["Apex Arzuros"] = true,
  ["Apex Mizutsune"] = true,
}

local font = nil
local icons = nil
local status = ""

re.on_draw_ui(
  function()
    if not imgui.collapsing_header("Compass") then return end

    local any_changed = false
    local changed = false
    local value   = nil

    changed, cfg.position = imgui.slider_int("Position", cfg.position, 10, 2000)
    any_changed = any_changed or changed

    changed, cfg.fov = imgui.slider_int("Field of view", cfg.fov, 60, 360)
    any_changed = any_changed or changed

    changed, cfg.width = imgui.slider_int("Main Line Width", cfg.width, 100, 2000)
    any_changed = any_changed or changed

    changed, cfg.main_line_color = imgui.color_edit_argb("Main Line Color", cfg.main_line_color)
    any_changed = any_changed or changed

    changed, cfg.cardinal_height = imgui.slider_int("Cardinal Lines Height", cfg.cardinal_height, 1, 200)
    any_changed = any_changed or changed

    changed, cfg.cardinal_thickness = imgui.slider_int("Cardinal Lines Thickness", cfg.cardinal_thickness, 1, 8)
    any_changed = any_changed or changed

    changed, cfg.cardinal_color = imgui.color_edit_argb("Cardinal Lines Color", cfg.cardinal_color)
    any_changed = any_changed or changed

    changed, cfg.aux_height = imgui.slider_int("Auxiliary Lines Height", cfg.aux_height, 1, 200)
    any_changed = any_changed or changed

    changed, cfg.aux_thickness = imgui.slider_int("Auxiliary Lines Thickness", cfg.aux_thickness, 1, 8)
    any_changed = any_changed or changed

    changed, cfg.aux_count = imgui.slider_int("Auxiliary Lines Count", cfg.aux_count, 0, 6)
    any_changed = any_changed or changed

    changed, cfg.aux_color = imgui.color_edit_argb("Auxiliary Lines Color", cfg.aux_color)
    any_changed = any_changed or changed

    changed, cfg.font_name = imgui.input_text("Font Name", cfg.font_name)
    any_changed = any_changed or changed
    if changed then
      font = d2d.Font.new(cfg.font_name, cfg.font_size)
    end

    changed, cfg.font_size = imgui.slider_int("Font Size", cfg.font_size, 1, 100)
    any_changed = any_changed or changed
    if changed then
      font = d2d.Font.new(cfg.font_name, cfg.font_size)
    end

    changed, cfg.icon_size = imgui.slider_int("Monster Icon Size", cfg.icon_size, 8, 64)
    any_changed = any_changed or changed

    changed, cfg.icon_below = imgui.checkbox("Monster Icon Below", cfg.icon_below)
    any_changed = any_changed or changed

    changed, cfg.icon_line_height = imgui.slider_int("Monster Line Height", cfg.icon_line_height, 1, 200)
    any_changed = any_changed or changed

    changed, cfg.icon_line_thickness = imgui.slider_int("Monster Line Thickness", cfg.icon_line_thickness, 1, 8)
    any_changed = any_changed or changed

    changed, cfg.icon_line_color = imgui.color_edit_argb("Monster Line Color", cfg.icon_line_color)
    any_changed = any_changed or changed

    changed, cfg.reticle_enabled = imgui.checkbox("Enable Reticle", cfg.reticle_enabled)
    any_changed = any_changed or changed

    changed, cfg.reticle_size = imgui.slider_int("Reticle Size", cfg.reticle_size, 2, 64)
    any_changed = any_changed or changed

    changed, cfg.reticle_thickness = imgui.slider_int("Reticle Thickness", cfg.reticle_thickness, 1, 8)
    any_changed = any_changed or changed

    changed, cfg.reticle_color = imgui.color_edit_argb("Reticle Color", cfg.reticle_color)
    any_changed = any_changed or changed

    if any_changed then
      json.dump_file("compass.json", cfg)
    end

    if string.len(status) > 0 then
      imgui.text("Status: " .. status)
    end
  end
)

function atan2(y, x)
  if math.abs(x) < 0.0001 then
    return 0
  else
    local angle = math.atan(y/x)
    angle = x > 0 and angle or angle + math.pi
    return angle % (2 * math.pi)
  end
end

local enemy_character_base_type_def = sdk.find_type_definition("snow.enemy.EnemyCharacterBase");
local enemy_type_field = enemy_character_base_type_def:get_field("<EnemyType>k__BackingField");
local message_manager_type_def = sdk.find_type_definition("snow.gui.MessageManager");
local get_enemy_name_message_method = message_manager_type_def:get_method("getEnemyNameMessage");

d2d.register(
  function()
    font = d2d.Font.new(cfg.font_name, cfg.font_size)

    icons = {
      question_mark = d2d.Image.new("question-mark.png")
    }
  end,
  function()
    -- Check if it should be running
    local quest_manager = sdk.get_managed_singleton("snow.QuestManager")
    if not quest_manager then
      status = "No quest manager"
      return
    end

    local quest_status = quest_manager:call("getStatus")
    if quest_status == nil then
      status = "No quest status"
      return
    end

    -- quest_status = 0 -> village
    --                1 -> loading quest
    --                2 -> on quest
    --                5 -> returning from quest
    if quest_status ~= 2 then return end

    --[[
    local is_result_demo_play_start_menu = quest_manager:call("isResultDemoPlayStart")
    if is_result_demo_play_start_menu ~= nil and is_result_demo_play_start_menu then
      status = "In result demo"
      return
    end
    --]]

    -- Get angles
    local player_manager = sdk.get_managed_singleton("snow.player.PlayerManager")
    if not player_manager then
      status = "No player manager"
      return
    end

    local player = player_manager:call("findMasterPlayer")
    if not player then
      status = "No local player"
      return
    end

    local player_game_obj = player:call("get_GameObject")
    if not player_game_obj then
      status = "No local player game object"
      return
    end

    local player_transform = player_game_obj:call("get_Transform")
    if not player_transform then
      status = "No local player transform"
      return
    end

    local player_position = player_transform:call("get_Position")
    if not player_position then
      status = "No local player transform position"
      return
    end

    local player_angle = player_transform:call("get_EulerAngle")
    if not player_angle then
      status = "No local player transform angle"
      return
    end

    local camera_manager = sdk.get_managed_singleton("snow.CameraManager")
    if not camera_manager then
      status = "No camera manager"
      return
    end

    local camera = camera_manager:call("get_RefPlayerCameraBehavior")
    if not camera then
      status = "No camera"
      return
    end

    local camera_angle = camera:call("get_CameraAngle")
    if not camera_angle then
      status = "No camera angle"
      return
    end

    local enemy_manager = sdk.get_managed_singleton("snow.enemy.EnemyManager")
    if not enemy_manager then
      status = "No enemy manager"
      return
    end

    -- Show compass
    local screen_w, screen_h = d2d.surface_size()

    local main_line_x = (screen_w - cfg.width) / 2
    d2d.line(main_line_x, cfg.position, main_line_x + cfg.width, cfg.position, 2, cfg.main_line_color)


    -- Auxiliaries
    -- to be easier, we draw over cardinals also, so we must include them in the total
    local total_aux_count = 4 * (cfg.aux_count + 1)
    for i = 0, total_aux_count do
      draw_aux_line(i * 360 / total_aux_count, camera_angle.y, main_line_x)
    end

    -- Cardinals
    draw_cardinal_line(0,   "S", camera_angle.y, main_line_x, font)
    draw_cardinal_line(90,  "E", camera_angle.y, main_line_x, font)
    draw_cardinal_line(180, "N", camera_angle.y, main_line_x, font)
    draw_cardinal_line(270, "W", camera_angle.y, main_line_x, font)

    -- Monster icons
    for i = 0, 4 do
      local enemy = enemy_manager:call("getBossEnemy", i)
      if not enemy then break end

      local enemy_game_obj = enemy:call("get_GameObject")
      if not enemy_game_obj then break end

      local enemy_transform = enemy_game_obj:call("get_Transform")
      if not enemy_transform then break end

      local enemy_position = enemy_transform:call("get_Position")
      if not enemy_position then break end

      local enemy_type = enemy_type_field:get_data(enemy)
      if not enemy_type then break end

      local enemy_name = get_enemy_name_message_method:call(enemy_manager, enemy_type)
      if not enemy_name then break end

      --[[
      str = "" .. enemy_type .. " " .. enemy_name
      text_w, text_h = d2d.measure_text(font, str)
      d2d.text(font, str, main_line_x, cfg.position + (i + 1) * text_h + cfg.cardinal_height / 2, 0xffffffff)
      --]]

      local delta_pos = enemy_position - player_position
      local angle = math.deg(atan2(delta_pos.x, delta_pos.z))

      draw_icon(angle, get_monster_icon(icons, enemy_name), camera_angle.y, main_line_x)
    end

    -- Reticle
    if cfg.reticle_enabled then
      d2d.outline_rect(
        screen_w / 2 - cfg.reticle_size / 2,
        cfg.position - cfg.reticle_size / 2,
        cfg.reticle_size,
        cfg.reticle_size,
        cfg.reticle_thickness,
        cfg.reticle_color
      )
    end
  end
)

function calculate_draw_position(angle, camera_angle, main_line_x, clamp)
  local fov = math.rad(cfg.fov)

  local diff = (math.rad(angle) - camera_angle) % (2 * math.pi)
  if diff > math.pi then
    diff = diff - 2 * math.pi
  end
  if math.abs(diff) > fov/2 then
    if clamp then
      diff = diff < 0 and -fov/2 or fov/2
    else
      return
    end
  end
  return main_line_x + cfg.width * (0.5 - diff / fov)
end

function draw_vertical_line(position, height, thickness, color)
  d2d.line(
    position,
    cfg.position - height / 2,
    position,
    cfg.position + height / 2,
    thickness,
    color
  )
end

function draw_cardinal_line(angle, str, camera_angle, main_line_x, font)
  local draw_pos = calculate_draw_position(angle, camera_angle, main_line_x, false)
  if draw_pos then
    draw_vertical_line(draw_pos, cfg.cardinal_height, cfg.cardinal_thickness, cfg.cardinal_color)
    local text_w, text_h = font.measure(font, str)
    d2d.text(font, str, draw_pos - text_w / 2, cfg.position - text_h - cfg.cardinal_height / 2, 0xffffffff)
  end
end

function draw_aux_line(angle, camera_angle, main_line_x)
  local draw_pos = calculate_draw_position(angle, camera_angle, main_line_x, false)
  if draw_pos then
    draw_vertical_line(draw_pos, cfg.aux_height, cfg.aux_thickness, cfg.aux_color)
  end
end

function get_monster_icon(icons, monster_name)
  if not monster_list[monster_name] then
    return icons.question_mark
  end

  if not icons[monster_name] then
    icons[monster_name] = d2d.Image.new(monster_name .. ".png")
  end

  return icons[monster_name]
end

function draw_icon(angle, image, camera_angle, main_line_x)
  local draw_pos = calculate_draw_position(angle, camera_angle, main_line_x, true)
  local delta_y = cfg.icon_below and 0 or -cfg.icon_size
  draw_vertical_line(draw_pos, cfg.icon_line_height, cfg.icon_line_thickness, cfg.icon_line_color)
  d2d.image(image, draw_pos - cfg.icon_size / 2, cfg.position + delta_y, cfg.icon_size, cfg.icon_size)
end
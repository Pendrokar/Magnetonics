
--  Custom Options Definition Table format

--  NOTES:
--  - using an enumerated table lets you specify the options order

--
--  These keywords must be lowercase for LuaParser to read them.
--
--  key:      the string used in the script.txt
--  name:     the displayed name
--  desc:     the description (could be used as a tooltip)
--  type:     the option type
--  def:      the default value
--  min:      minimum value for number options
--  max:      maximum value for number options
--  step:     quantization step, aligned to the def value
--  maxlen:   the maximum string length for string options
--  items:    array of item strings for list options
--  scope:    'all', 'player', 'team', 'allyteam'      <<< not supported yet >>>
--

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Example ModOptions.lua
--

local options = {
  {
       key="magnetonics",
       name="Options",
       desc="Options",
       type="section",
  },
  {
    key="startoptions",
    name="Game Modes",
    desc="Change the game mode",
    type="list",
    def="normal",
    section="magnetonics",
    items={
      {key="normal", name="Normal", desc="Normal game mode"},
      {
        key  = 'koth',
        name = 'King of the Hill',
        desc = 'Control the hill for a set amount of time to win! See King of the Hill section.',
      },
    }
  },
  {
    key='hilltime',
    name='Hill control time',
    desc='Set how long a team has to control the hill for (in minutes).',
    type='number',
    def=3,
    min=1,
    max=30,
    step=1.0,
    section='magnetonics',
  },
  {
    key='gracetime',
    name='No control grace period',
    desc='No player can control the hill until period is over.',
    type="number",
    def=0,
    min=0,
    max=5,
    step=0.5,
    section="magnetonics",
  },
}

return options


module Harmonize
  class HarmonizeError < StandardError ; end
  class DuplicateHarmonizerName < HarmonizeError ; end
  class UnknownHarmonizerName < HarmonizeError ; end
  class HarmonizerSourceUndefined < HarmonizeError ; end
  class HarmonizerTargetUndefined < HarmonizeError ; end
  class HarmonizerTargetInvalid < HarmonizeError ; end
end

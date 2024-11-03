--function to toggle peloton on
function TogglePeloton()
  if PandoraGetFeatureEnabled('Auto-Peloton') then
      yield('/echo Disabling Auto-Peloton.')
      PandoraSetFeatureState('Auto-Peloton',false)
  else
      yield('/echo Enabling Auto-Peloton.')
      PandoraSetFeatureState('Auto-Peloton',true)
  end


end

--not messing with featureconfigstate, I like all the suboptions the way I have them thanks, just doing the feature itself

--just do it
TogglePeloton()
--function to toggle peloton on
function TogglePelotonOn()
  if PandoraGetFeatureEnabled('Auto-Peloton') then
      yield('/echo Disabling Auto-Peloton.')
      PandoraSetFeatureState('Auto-Peloton',false)
  else
      yield('/echo Enabling Auto-Peloton.')
      PandoraSetFeatureState('Auto-Peloton',true)
  end


end

--not messing with featureconfigstate, I like all the suboptions the way I have them thanks

--just do it
TogglePelotonOn()

::Hooks.TreeHooks <- [];

::Hooks.__rawHookTree = function(_mod, _src, _func)
{
	this.__initClass(_src);
	// useful for debugging
	this.BBClass[_src].TreeHooks.push({
		Mod = _mod,
		hook = _func
	});
	// actually used by the queue logic
	this.TreeHooks.push({
		Target = this.BBClass[_src],
		Mod = _mod,
		hook = _func,
		Src = _src,
	});
}

::Hooks.__finalizeHooks = function()
{
	local root = getroottable();
	foreach (src, bbclass in this.BBClass)
	{
		// normal hook logic
		if (!bbclass.Processed)
		{
			if (bbclass.Prototype == null)
			{
				local warnString = format("The BB class '%s' was never proceessed for hooks", src);
				local relevantMods = bbclass.RawHooks.map(@(hookInfo) format("%s (%s)", hookInfo.Mod.getID(), hookInfo.Mod.getName())).reduce(@(a, b) a + ", " + b);

				if (relevantMods != null)
					warnString += format(", it was targeted by %s with normal hooks", relevantMods);
				local relevantTreeMods = bbclass.TreeHooks.map(@(hookInfo) format("%s (%s)", hookInfo.Mod.getID(), hookInfo.Mod.getName())).reduce(@(a, b) a + ", " + b)
				if (relevantTreeMods != null)
				{
					if (relevantMods != null)
						warnString += " and";
					else
						warnString += ", it was targeted by";
					warnString += format(" %s with tree hooks", relevantTreeMods);
				}

				::Hooks.warn(warnString);
				continue;
			}
			this.__processRawHooks(src);
		}
	}
	// leaf hook logic
	foreach (hookInfo in this.TreeHooks)
	{
		foreach (p in hookInfo.Target.Descendants)
		{
			try
			{
				hookInfo.hook.call(root, p);
			}
			catch (error)
			{
				local versionString = typeof hookInfo.Mod.getVersion() == "float" ? hookInfo.Mod.getVersion().tostring() : hookInfo.Mod.getVersion().getVersionString();
				::Hooks.errorAndQuit(format("Mod %s (%s) version %s had an error (%s) during its tree hook on bb class %s.", hookInfo.Mod.getID(), hookInfo.Mod.getName(), versionString, error, hookInfo.Src));
			}
		}
	}
}

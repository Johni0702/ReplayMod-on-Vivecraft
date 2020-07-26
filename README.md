This repository contains instructions for running [ReplayMod] on [Vivecraft] (or similar LaunchWrapper-based mods), using MultiMC.

To run ReplayMod alongside Vivecraft, a special version of it and fabric-api needs to be built.
To do so, run `build.sh`. Beware that it builds a loom version which is not compatible with the normal loom, so if you need regular loom for other development, be sure to run this as a temporary user, so you can easily clean up after it.

Once built, you should find a replaymod jar, a fabric-loader jar and a bunch of other fabric jars in the same folder.
To use those with Vivecraft, firstly install the Vivecraft companion mod into a new MultiMC instance as usual.
Once complete, install Fabric Loader as usual via MultiMC into the same instance.
Now for the tricky bits:
- Select `Fabric Loader` from the Version list, click `Customize`, click `Edit`
- Replace the last entry in the `libraries` array (should be the `fabric-loader` entry) with:
```
        {
            "name": "net.fabricmc:fabric-loader:0.9.0+local",
            "MMC-hint": "local"
        }
```
- Change the value of `mainClass` from `net.fabricmc.loader.launch.knot.KnotClient` to `net.minecraft.launchwrapper.Launch`
- Add `"+tweakers": [ "net.fabricmc.loader.launch.FabricClientTweaker" ],` in the line below the `mainClass`
- Remove the entire `requires` section (5 lines)
- Save and close the file
- Click `Reload` in MultiMC (the `Intermediary Mappings` entry should disappear)
- Make sure `Vivecraft` is above `Fabric Loader`
- Select `Vivecraft` from the Version list, click `Edit`
- Remove the section containing `org.ow2.asm:asm-all:5.2` (4 lines)
- Save and close the file
- Click `Open Libraries`
- Place the fabric-loader jar into this folder (there should already be a vivecraft and a optifine jar there), then close it again
- Click `Reload` in MultiMC again
- Place the remaining jars into your `mods` folder as usual
- Launch

For future upgrade operations, consider opting into Chocolatey's `useRememberedArgumentsForUpgrades` feature to avoid having to pass the same arguments with each upgrade:
```
choco feature enable -n=useRememberedArgumentsForUpgrades
```
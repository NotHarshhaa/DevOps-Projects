# Example InSpec Profile For Azure

This example shows the implementation of an InSpec profile for Azure. See [https://github.com/inspec/inspec-azure](https://github.com/inspec/inspec-azure) for details on how to configure credentials for your subscription.

##  Create a profile 

```
$ inspec init profile --platform azure my-profile

 ─────────────────────────── InSpec Code Generator ───────────────────────────

Creating new profile at /Users/spaterson/my-profile
 • Creating directory libraries
 • Creating file README.md
 • Creating directory controls
 • Creating file controls/example.rb
 • Creating file inspec.yml
 • Creating file libraries/.gitkeep
 
```

## Run the tests

```
$ cd  my-profile/
$ inspec exec . -t azure://


Profile: Azure InSpec Profile (my-profile)
Version: 0.1.0
Target:  azure://12345abc-987d-654e-fg21-abcdef23324r

  ×  azure-virtual-machines-exist-check: Check resource groups to see if any VMs exist. (4 failed)
     ×  Azure Virtual Machines should exist
     expected Azure Virtual Machines to exist
     ×  Azure Virtual Machines should exist
     expected Azure Virtual Machines to exist
     ×  Azure Virtual Machines should exist
     expected Azure Virtual Machines to exist
     ×  Azure Virtual Machines should exist
     expected Azure Virtual Machines to exist
     ✔  Azure Virtual Machines should exist
     ✔  Azure Virtual Machines should exist
     ✔  Azure Virtual Machines should exist


Profile: Azure Resource Pack (inspec-azure)
Version: 1.2.0
Target:  azure://12345abc-987d-654e-fg21-abcdef23324r

     No tests executed.

Profile Summary: 0 successful controls, 1 control failure, 0 controls skipped
Test Summary: 3 successful, 4 failures, 0 skipped

```
Port pvmfw from OnePlus 13 to Pad with github action
=============================================================

> # !Attention:
> ## Haven't test on my device!

Features
========
- Port pvmfw from OnePlus 13 to OnePlus Pad Pro (Pad 2)
- Microdroid works

Attention
========
- Backup your data
- The modified images you flash need to be the same as the OS version your OnePlus Pad Pro is running

Guide
======
1. Fork this repo
1. Go to the **Action** tab in your forked repo
    ![Action Tab](https://docs.github.com/assets/images/help/repository/actions-tab.png)
1. In the left sidebar, click the **Pvmfw Port Application** workflow.
    ![Workflow](https://docs.github.com/assets/images/help/repository/actions-quickstart-workflow-sidebar.png)
1. Above the list of workflow runs, select **Run workflow**
    ![Run Workflow](https://docs.github.com/assets/images/help/actions/actions-workflow-dispatch.png)
1. Input your rom url of OnePlus Pad Pro and OnePlus 13 and click **Run workflow**
    ![Run Workflow](https://docs.github.com/assets/images/help/actions/workflow-dispatch-inputs.png)
1. Wait for the action to complete and download the artifact **DO NOT download it via multithread downloaders like IDM or ADM**
    ![Download](https://docs.github.com/assets/images/help/repository/artifact-drop-down-updated.png)
1. Unzip the artifact named output
1. Backup your data first, and flash images to your OnePlus Pad Pro
```
//Flash images
fastboot flash pvmfw pvmfw.img
fastboot flash vbmeta_system vbmeta_system_mod.img
fastboot flash vendor_boot vendor_boot_mod.img
//Format userdata and reboot
fastboot -w
fastboot reboot
```
9. If booted to android os, run microdroid
```
adb shell /apex/com.android.virt/bin/vm run-microdroid --protected
```
10. Restore to stock rom
```
//Flash images
fastboot erase pvmfw
fastboot flash vbmeta_system vbmeta_system.img
fastboot flash vendor_boot vendor_boot.img
//Format userdata and reboot
fastboot -w
fastboot reboot
```
About  Protected VMs in Android Virtualization Framework
========
[Android Virtualization Framework](https://source.android.com/docs/core/virtualization)  
[Gunyah Hypervisor Software - Supporting Protected VMs in Android Virtualization Framework](https://www.qualcomm.com/developer/blog/2024/01/gunyah-hypervisor-software-supporting-protected-vms-android-virtualization-framework)  

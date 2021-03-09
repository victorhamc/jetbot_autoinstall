# jetbot_autoinstall script

Automated way to install pytorch, torchvision, torch2trt, trt-pose using a simple sh script

## Running the semi-automated install script

```
    cd auto_install_script
    chmod +x jetbot_auto_install.sh
    ./jetbot_auto_install.sh
```
### Running other scripts

+ [SWAP] This will create a swap file, enable swap (default to 4G) and add the entry to fstab

```
    cd other_scripts
    chmod +x enable_swap.sh
    ./enable_swap.sh
```

## References

+ [Pytorch, torchvision and deps] https://forums.developer.nvidia.com/t/pytorch-for-jetson-version-1-7-0-now-available/72048
+ [Swap] https://github.com/NVIDIA-AI-IOT/jetbot/blob/master/scripts
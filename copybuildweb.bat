@echo off
rmdir "D:\DEV\Flutter\projector_management\buildweb"
mkdir "D:\DEV\Flutter\projector_management\buildweb"
xcopy "D:\DEV\Flutter\projector_management\build\web" "D:\DEV\Flutter\projector_management\buildweb" /s /e
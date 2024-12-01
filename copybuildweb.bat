@echo off

rmdir "D:\DEV\Flutter\projector_management\buildweb" /S /Q
mkdir "D:\DEV\Flutter\projector_management\buildweb"
xcopy "D:\DEV\Flutter\projector_management\build\web" "D:\DEV\Flutter\projector_management\buildweb" /s /e
git add .
git commit -m "update"
git push -u origin main
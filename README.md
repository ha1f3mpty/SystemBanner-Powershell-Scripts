# SystemBanner

-----
ABOUT
-----

SystemBanner is an application used to display information security attributes or classification markings applicable for the Windows systems it runs on.

SystemBanner was built with standards in mind. For example, SystemBanner comes out of the box with Group Policy templates that can configure SystemBanner to display the different levels of United States Classified National Security Information as defined by EO 13526, as amended, and United States Controlled Unclassified Information as defined by EO 13556, as amended.

![Alt text](Docs/Images/SystemBanner_Working_Screenshot.png?raw=true)

In addition, custom options implemented in Group Policy which sets relevant Registry values allow for other types of organizations to display custom messages and colors to warn users of Windows-based computers of the sensitivity of the information displayed, such as PII, PHI, Proprietary, or any kind of text-based marking or warning.

![Alt text](Docs/Images/SystemBanner_GPO_Screenshot.png?raw=true)
![Alt text](Docs/Images/SystemBanner_Custom_Screenshot.png?raw=true)

SystemBanner displays the selected message to the user as soon as they are logged into Windows via one or more graphical SystemBanner AppBars. As the user connects to new displays or resizes existing ones, SystemBanner regenerates new SystemBanner AppBars to accommodate those changes. If fullscreen apps are detected, or the user moves their mouse over the SystemBanner, the opacity of the SystemBanner will decrease to allow visibility to objects behind the SystemBanner without fully hiding the relevant security attribute information displayed. 

SystemBanner is a C# .NET Framework 4.7.2 Windows Forms Application that uses Group Policy and Registry values to maintain configuration variables and ensure that the application runs on logon. It uses the Win32 Shell AutoHideAppBarEX window type to generate AppBars on each screen. 

Unlike Microsoft NetBanner, which is unavailable to the public, full screen opacity choices made available by SystemBanner ensure that full screen applications (like videos) do not fully cover the SystemBanner. Additionally, some applications that do not adhere to standard window formatting (which can obscure Microsoft NetBanner) do not interfere with the visibility of SystemBanner generated markings. Lastly, out of the box support for custom colors and CUI markings allows this application to be used in the Defense Industrial Base, private sector, and other locations where security banners are useful or required. 

SystemBanner has been tested to work on Windows 10/11 and Windows Server 2016/2019/2022/2025 with full functionality (including support for x86_64 and arm64 architectures). Limited functionality may be available on other versions of Windows that support .NET Framework 4.7.2 or above.

------------
INSTALLATION
------------

To install SystemBanner, either install SystemBannerSetup.msi (double click, msiexec via CLI, etc.) or download the project ZIP and run InstallSystemBanner.bat as an administrator. 

![Alt text](Docs/Images/SystemBanner_Install_Screenshot.png?raw=true)

Each installer copies the SystemBanner Binary (SystemBanner.exe) to "C:\Program Files\SystemBanner", copies ADMX and ADML files (for Group Policy Functionality) to C:\Windows\PolicyDefinitions\ and C:\Windows\PolicyDefinitions\en-US\, creates a startup app registry key for SystemBanner to run on logon of any user, and puts a Registry value into "HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" to allow SystemBanner to be High DPI aware (ignore Windows Scaling). When installing with the MSI, SystemBanner will start the next time the user logs in or the next time the user runs C:\Program Files\SystemBanner\SystemBanner.exe, whichever happens first. 

-------
REMOVAL
-------

To remove SystemBanner, either remove SystemBannerSetup.msi or run RemoveSystemBanner.bat as an administrator.

Each removal method kills all running instances of SystemBanner.exe, then deletes "C:\Program Files\SystemBanner\SystemBanner.exe", the "C:\Program Files\SystemBanner" folder, all SystemBanner ADMX and ADML files from C:\Windows\PolicyDefinitions\ and C:\Windows\PolicyDefinitions\en-US\, and removes itself as a startup app and HIGHDPIAWARE app in registry. Restarting Explorer.exe may clean up any remaining AppBar API calls that have not been cleaned up (the space the Banner makes for itself in the Windows UI).

--------------
ADMINISTRATION
--------------

SystemBanner comes out of the box with Group Policy templates to configure the security information displayed to the user. The ADMX/ADML files can be used to locally manage policy or they can be loaded onto a domain controller for domain-wide management. In either scenario, configuration items are located in Computer Configuration > Administrative Templates > SystemBanner. Once configuration changes are made, most are picked up by SystemBanner automatically while running. Custom color changes require an application restart at this time. 

Active Directory Administrators - please manually copy the ADMX/ADML files to their appropriate locations on your domain controller to allow for Group Policy configuration of SystemBanner across your Domain or Forest.

Intune Administrators - ADMX/ADML importing appears to be on the roadmap (https://learn.microsoft.com/en-us/intune/device-configuration/settings-catalog/import-custom-admx-templates). Until then, please use Local GPO to test/build your desired configuration, then deploy the corresponding registry values (HKEY_LOCAL_MACHINE\SOFTWARE\Policies\SystemBanner) to your fleet.

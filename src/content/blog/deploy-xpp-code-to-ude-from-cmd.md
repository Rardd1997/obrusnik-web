---
title: "Deploy X++ code to UDE from cmd"
description: "How to deploy X++ code to unified developer environment from command line"
pubDate: "Jun 06 2026"
blogImage: "../../assets/blog-d365fo.webp"
category: "D365FO"
tags: ["Deployment", "UDE", "Tutorial"]
---

Recently I have been having problems with the microsoft-hosted pipeline.
It has a 60 minute timeout that cannot be increased in any way, but our repository contains more than 30 models that need to be build and deployed to LCS and UDE and if only build done by up to 50mins, but with pacakge generation it running more that 60. Some may say that it is worth dividing the pipeline into several smaller ones, but "the samurai does not see the goal, only the path".

I have a DEV environment with a right application version for our UAT in which I have created a well-known Deployable package, which I then converted to a Unified package and deployed to the environment I need.

Below is a list of the steps I took:
1) Created a Deployable package from Visual Studio
2) Converted the resulting package to a Unified package
```
.\ModelUtil.exe -convertToUnifiedPackage -file="C:\Temp\AXDeployablePackage.zip" -outputpath="C:\Temp\Uni\"
```
3) Downloaded and installed [powerapps-cli](https://learn.microsoft.com/en-us/power-platform/developer/howto/install-cli-msi)
4) Logged into the UDE environment I needed and ran package deploy
```
pac auth create --environment https://<your-ude>.crm4.dynamics.com
pac package deploy --logConsole --package "C:\Temp\Uni\TemplatePackage.dll"
```
 
## More Links
- [Install Power Platform CLI](https://learn.microsoft.com/en-us/power-platform/developer/howto/install-cli-msi)
- [Legacy package conversion and deployment](https://downardo.at/wiki/Documentation/Unified%20Experience/convertAndDeployPackage/)
- [Dynamics 365 FinOps Unified developer experience](https://www.powerazure365.com/blog-1/dynamics-365-finops-unified-developer-experience)
- [UDE Instance Package Deployment](https://community.dynamics.com/forums/thread/details/?threadid=9a07491d-2b95-f011-b4cc-00224830b09a)
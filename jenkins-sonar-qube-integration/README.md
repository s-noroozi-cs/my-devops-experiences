# JenkinsSonarQubeIntegration
Integration between Jenkins and SonarQube in analyzing code and check status of quality gate to fail or pass Jenkins build job. 

I would like to use SonarQube scanner as one part of Jenkins pipeline. When status of quality gate of sonar scanner failed, then failed current build job of Jenkins. 

There are exist many plugin in Jenkins that help to make integration with SonarQube, but  due to the deprecation of plugin version (upgrading Jenkins version) or changing SonarQube treat (asynchronies mechanism in code analyzing), I can’t use them. 

SonarQube provide rich Rest APIs that cover most of its functionality.  One of nicest plugin of Jenkins is Shell script plugin that provide facility to execute Shell script. I use combine shell script task to combine some of rest APIs of SonarQube to satisfy our requirement. 

Our requirement was check code quality as one of Jenkins pipeline same as build, test and etc. Then if quality gate of SonarQube was failed, then failed Jenkins current build job.

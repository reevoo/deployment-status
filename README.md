# deployment-status - A public status page for our deployments

The purpose of this webapp is to address the situation where a client experiences a problem with their own production instance (i.e. a javascript deploy which clashes with their code) and they are trying to see if Reevoo may have been a contributory cause
It is not a mechanism to tell customers that their bugs have been fixed (they get notifications from support for that)
It is also not a mechanism to inform them of the arrival of new features (Customer Success do email campaigns and webinars for that)
It’s simply a first stop for the client as part of their debugging when they have their own issues.

The deployment status is posted by Jira, when a ticket is marked as "deployed". I don't know exactly how this works so if you know more please update this README.

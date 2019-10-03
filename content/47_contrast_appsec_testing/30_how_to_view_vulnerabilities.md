+++
title = "How to view vulnerabilities in Contrast"
chapter = false
weight = 30
+++

There are several options to acquire information about vulnerabilities in Contrast Security:

- In the Contrast UI
- Programmatically via API requests
- Through various integrations (Jira, Slack, IDEs, etc.)


### Vulnerabilities in Contrast Security UI

1. Log in Contrast Security Community Edition
2. Click on Vulnerabilities in the top menu to see all vulnerabilities for all instrumented applications. In our case, it will be just for WebGoat:

{{< figure src="/images/contrast/ce_view_vuln.png" style="border: 1px solid #000; max-width:auto; max-height:auto;">}}

You can click on each vulnerabilities to get more information. Please note that we have done any work yet but still able to see some vulnerabilities that Contrast was able to identify.

### Getting access to vulnerabilities via API

Please review [the API documentation] (https://api.contrastsecurity.com)

Here is a sample API call to get a brief summary of found vulnerabilities:

```bash
curl -X GET https://c.contrastsecurity.com/Contrast/api/ng/{orgUuid}/traces/{appId}/quick -H 'Authorization:{authorization-key}' -H 'API-Key:{API-Key}'
```
The output will look like this:

```bash
{
  "success" : true,
  "messages" : [ "Vulnerability quick filters loaded successfully" ],
  "filters" : [ {
    "name" : "All",
    "count" : 18,
    "filterType" : "ALL"
  }, {
    "name" : "Open",
    "count" : 18,
    "filterType" : "OPEN"
  }, {
    "name" : "High Confidence",
    "count" : 0,
    "filterType" : "HIGH_CONFIDENCE"
  } ]
}
```
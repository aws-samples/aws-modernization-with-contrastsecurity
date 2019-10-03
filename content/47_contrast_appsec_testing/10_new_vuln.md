+++
title = "How to discover a new vulnerability"
chapter = false
weight = 10
+++

### Application Vulnerabilities
In this part we will discover a new vulnerability in Webgoat application and examine the finding in Contrast Security.

It is important to reiterate that Contrast Security identifies vulnerabilities by looking at the normal traffic that goes through the application. With that in mind, let's identify a SQL injection vulnerability within Webgoat using Contrast.

1. Use the username `webgoat` and password `webgoat` to log into the Webgoat application.

2. Navigate to the `Injection Flaws` --> `String SQL injection` lesson.

3. Within the `Enter your last name:` textbox, enter `Smith` or any other string into the field and click on `Go` button:

{{< figure src="/images/contrast/wg_1.png" style="border: 1px solid #000; max-width:auto; max-height:auto;">}}

When you perform this action, Contrast is passively monitoring the security of the application including the request made to the application, how that request is handled by the application, and other actions such as queries to the database layer.

4. Now switch back to Contrast Security platform and click on V`ulnerabilities` tab within the `WebGoat` application. As you can see, the Contrast agent has identified two new vulnerabilities: `Cross-Site Scripting (XSS)` and `SQL injection`.

{{< figure src="/images/contrast/ce_4.png" style="border: 1px solid #000; max-width:auto; max-height:auto;">}}

5. Click on either of these vulnerabilities to get more detailed information, such as:
    * `Details` describing the data flow of the vulnerability from `source` to `sink` including any `propagators`.
    * `HTTP Info` that shows the query string parameters, request body, and headers associated with the request.
    * `How to Fix` information providing different approaches to remediating this type of vulnerability.
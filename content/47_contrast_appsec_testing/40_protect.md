+++
title = "Protecting Your Application in Production"
chapter = false
weight = 40
+++

### Protecting Your Application in Production
The same technology used to find vulnerabilities early within the SDLC can also be extended int applications running in production environments. If enabled within these environments, attacks against the application layer can be monitored and blocked by Contrast.

In your Community Edition, this feature is already enabled by default. You can see this by navigating to the `Policy` submenu within the WebGoat application:

{{< figure src="/images/contrast/ce_5.png" style="border: 1px solid #000; max-width:auto; max-height:auto;">}}

As you can see, Contrast Security is already actively protecting the application from being exploited by many common attacks.

Let's try attacking the application with exploit designed for the `SQL Injection` vulnerability that Contrast discovered on the previous step.

1. Go back to the WebGoat site and go to `Injection Flaws` --> `String SQL injection`.
2. Add the following payload into the text field: `Smith' or '98'='98`.
3. Click `Go`

Normally, this would result in the entire database being returned back to the calling user. In this case, you will see that no results have found as Contrast is protecting the application. 

{{< figure src="/images/contrast/wg_3.png" style="border: 1px solid #000; max-width:auto; max-height:auto;">}}

However if you try a regular query like `Smith`, the request will go through and WebGoat will return some data, so it is not blocking legitimate requests.

Now let's try to turn `Protect` off and let's see what happens. If we go back to Contrast, we can turn off the `SQL Injection` rule as shown here:

{{< figure src="/images/contrast/ce_6.png" style="border: 1px solid #000; max-width:auto; max-height:auto;">}}

Now you try to exploit WebGoat again and see what happens.
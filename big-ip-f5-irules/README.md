# BigIP-F5-CheckCertificate-Field
Checking client certificates during TLS connection based on your company policies

I am working on application that provide REST API interface to our customers.

Our application work behind F5. 

We use F5 hard ware as WAF and load balancer.

Our clients force to use two-way TLS with F5, Also F5 force to use two-way TLS with our server. 

All certificates must be sign through our trusted CA. We add certificate of our CA as trust manager in application server and F5. 

In addition signed certificate, we must have registration mechanism for client s certificates. 

In registration flows, we check some attribute of certificate such as common name (CN), Owner (O) and also serial number. 

F5 provides data group and iRule features to achieve these requirements. 

Registered information manage through data group, also checking and validation of certificates done in F5-iRule.

Testing your script with **TesTcl**

Comprehensive article: https://www.linkedin.com/pulse/f5-big-ip-saeid-noroozi-xmocf/?trackingId=ZJ0abw7%2BQVdApu2Rml4dlw%3D%3D

# blackbox-exporter
Trialing usage of blackbox-exporter within my monitoring setup.  I am using `prom/blackbox-exporter` to expose a probe endpoint that prometheus can 'scrape'.  For the trial, I will be probing CloudFlare's DoH (DNS over HTTPS) status endpoint to monitor that DNS requests are indeed routed via CF DoH thru my pihole setup.

## Usage
* URL to check current DoH status: https://bbd96f23-eda8-465d-b190-6ddf056cae66.is-doh.cloudflareresolve.com/resolvertest
* URL for Prometheus to scrape: http://blackbox-exporter:9115/probe?target=bbd96f23-eda8-465d-b190-6ddf056cae66.is-doh.cloudflareresolve.com/resolvertest&module=http_2xx_expect_1


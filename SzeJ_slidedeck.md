<!-- $theme: default -->

<!-- page_number: true -->

<!-- footer:  2019 Pennsylvania Economic Association Annual Conference May 31 2019 -->

# An Evaluation of the Impact of Leading Pedestrian Interval Signals in NYC

### Jeremy J. Sze
Hunter College, The City University of New York

[Jeremy.Sze@outlook.com](mailto:Jeremy.Sze@outlook.com)

[https://jeremysze.github.io](https://jeremysze.github.io)

---
# 1. Introduction

---
![visionzeronyc.png](images/visionzeronyc.png)
![nyc_streets.jpg](images/nyc_streets.jpg)
<sub><sub><sub><sup> Source: https://www.flickr.com/photos/romankphoto/</sup></sub></sub></sub>

---
## Leading Pedestrian Interval Signals (LPIs)
![LPIS_visualization.png](images/LPIS_visualization.png)

<sub><sub><sub><sup> Source: [https://nacto.org/publication/urban-street-design-guide/intersection-design-elements/traffic-signals/leading-pedestrian-interval/](https://nacto.org/publication/urban-street-design-guide/intersection-design-elements/traffic-signals/leading-pedestrian-interval/)</sup></sub></sub></sub>

---
![lpis%20map2.png](images/lpis%20map2.png)

---
## NYPD Motor Vehicle Collisions
* From July 2012 to September 2018
* Approximately 1.35 million collisions were recorded

Includes: 
* collision outcomes, coordinates, streets, borough, zip code, time, vehicle type, contributing factors

Stratified:
* 11.00 p.m. to 4.59 a.m.
* 5.00 a.m. to 10.59 p.m.

---
![dailycollisions.png](images/dailycollisions.png)

---
![dailycollisions_stratified.png](images/dailycollisions_stratified.png)

---
![dailypersonsinjuries.png](images/dailypersonsinjuries.png)

---
![dailypedestriansinjuries.png](images/dailypedestriansinjuries.png)

---
![dailycyclistinjuries.png](images/dailycyclistinjuries.png)

---
![dailymotoristinjuries.png](images/dailymotoristinjuries.png)

---
![dailyall.png](images/dailyall.png)

---
![graph_of_time_trend_average_small.png](images/graph_of_time_trend_average_small.png)

---
## Hypothesis

The introduction of LPIs reduced collisions and injuries

---
  # 2. Challenges and Solution

---
## Selective implementation
![collision_lpis_overlay.png](images/collision_lpis_overlay.png)

---
## Phased introduction
![lpis_year_install_2013_2014.png](images/lpis_year_install_2013_2014.png)

---
## Phased introduction
![lpis_year_install_2013_2016.png](imageslpis_year_install_2013_2016.png)

---
## Phased introduction
![lpis_year_install_2013_2018.png](images/lpis_year_install_2013_2018.png)

---
## Unobserved heterogeneity
![satalite_screenshot.png](images//satalite_screenshot.png)

---
## Spatial autocorrelation
![NYC_collisions_deciles.png](images//NYC_collisions_deciles.png)

---
## Spatial autocorrelation
![NYC_collisions_deciles_lagged.png](images//NYC_collisions_deciles_lagged.png)

---
### General Binary treatment Difference-in-difference model

* Simplifying from 25 quarters, we can think of it as there being 3 different groups
* untreated group $U$
* early treatment group $k$ that receives treatment at $t^*_k$
* late treatment group $l$ that receives treatment at $t^*_l$

---

### General Binary treatment Difference-in-difference model

![Generalized_DiD.png](images/Generalized_DiD.png)

---
## Assumptions
* Unmeasured determinants of the outcomes were time invariant or group invariant
* Common trends assumption
* Timing of the treatment implementation must be statistically independent of the potential outcomes distributions, conditional on the group-and time-fixed effects

---
# 3. Results
---
## Model Specifications and controls
* Indicator for when intersections received LPIs intervention
* Indicator for when Bike route was built
* Indicator for when Street Improvement was implemented
* Indicator for when Left Turn intervention was implemented
* School Zone trends
* Senior Zone trends
* Priority Intersections trends
* Time effects
* Intersection fixed effects

---

## NYC Fixed effects DiD (Pooled)
![NYC_collisions_pooled_visuals.png](images/NYC_collisions_pooled_visuals.png)

---
## NYC Fixed effects DiD (Pooled)
![NYC_collisions_pooled_visuals_percent.png](images/NYC_collisions_pooled_visuals_percent.png)

---

## NYC Fixed Effects DiD (Late Night)
![NYC_collisions_latenight_visuals.png](images/NYC_collisions_latenight_visuals.png)

---

## NYC Fixed Effects DiD (Non-late night)
![NYC_collisions_nonlatenight_visuals.png](images/NYC_collisions_nonlatenight_visuals.png)

---
## Spatial Lagged Overall Impact Fixed Effects DiD (Manhattan)
![Manhattan_collisions_overall_visuals.png](images/Manhattan_collisions_overall_visuals.png)

---
## Spatial Lagged Overall Impact Fixed Effects DiD (Manhattan)
![Manhattan_collisions_overall_visuals_percent.png](images/Manhattan_collisions_overall_visuals_percent.png)

---
## Questions? 
### Thank you!
[Jeremy.Sze@outlook.com](mailto:Jeremy.Sze@outlook.com)

[https://jeremysze.github.io](https://jeremysze.github.io)
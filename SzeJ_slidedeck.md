<!-- $theme: default -->

<!-- page_number: true -->

# An Evaluation of the Impact of Leading Pedestrian Interval Signals in NYC

### Jeremy J. Sze
Hunter College, The City University of New York

[Jeremy.Sze@outlook.com](mailto:Jeremy.Sze@outlook.com)

[https://jeremysze.github.io](https://jeremysze.github.io)

---
# 1. Introduction

---
![visionzeronyc.png](../manuscripts/visionzeronyc.png)
![nyc_streets.jpg](../manuscripts/nyc_streets.jpg)
<sub><sub><sub><sup> Source: https://www.flickr.com/photos/romankphoto/</sup></sub></sub></sub>

---
## Leading Pedestrian Interval Signals (LPIs)
![LPIS_visualization.png](../manuscripts/LPIS_visualization.png)

<sub><sub><sub><sup> Source: [https://nacto.org/publication/urban-street-design-guide/intersection-design-elements/traffic-signals/leading-pedestrian-interval/](https://nacto.org/publication/urban-street-design-guide/intersection-design-elements/traffic-signals/leading-pedestrian-interval/)</sup></sub></sub></sub>

---
![lpis%20map2.png](../manuscripts/lpis%20map2.png)

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
![dailycollisions.png](../manuscripts/dailycollisions.png)

---
![dailypersonsinjuries.png](../manuscripts/dailypersonsinjuries.png)

---
![dailypedestriansinjuries.png](../manuscripts/dailypedestriansinjuries.png)


---
![dailycyclistinjuries.png](../manuscripts/dailycyclistinjuries.png)

---
![dailymotoristinjuries.png](../manuscripts/dailymotoristinjuries.png)

---
![dailyall.png](../manuscripts/dailyall.png)

---





## Figure 2: Average collisions by intersection type
![graph_of_time_trend_average_small.png](../manuscripts/graph_of_time_trend_average_small.png)

---
## Hypothesis

The introduction of LPIs reduced collisions and injuries

---
# 2. Challenges and Solution

---
## Selective implementation
![collision_lpis_overlay.png](../manuscripts/collision_lpis_overlay.png)

---
## Phased introduction
![lpis_year_install.png](../manuscripts/lpis_year_install.png)

---
## Unobserved heterogeneity
![satalite_screenshot.png](../manuscripts/satalite_screenshot.png)

---
## Spatial autocorrelation
![spatial_autocorrelation.png](../manuscripts/spatial_autocorrelation.png)

---
## Goodman-Baconâ€™s general binary treatment difference-in-difference model
* Simplifying from 25 quarters, we can think of it as there being 3 different groups
    * untreated group $U$
    * early treatment group $k$ that receives treatment at $t^*_k$
    * late treatment group $l$ that receives treatment at $t^*_l$
* Intersections that received the LPIs intervention at a later period after $t^*_l$, hence in the periods before that, they act as controls to intersections that had received LPIs intervention at $t^*_k$
* 
---
## Assumptions
* Unmeasured determinants of the outcomes were time invariant or group invariant
* Common trends assumption
* Timing of the treatment implementation â€œmust be statistically independent of the potential outcomes distributions, conditional on the group-and time-fixed effects

---
# 3. Results
---
### Model Specifications
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

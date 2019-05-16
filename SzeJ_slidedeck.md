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


## Leading Pedestrian Interval Signals (LPIs)
* Pedestrians a few seconds head start
* 2,689 intersections
* Director of Signals Timing Engineering to learn about how the LPIs intersections were selected by the DOT
* Part of [NYC's Vision Zero initiative](https://www1.nyc.gov/site/visionzero/index.page)
---
![dailycollisions.png](../manuscripts/dailycollisions.png)

---
![lpis%20map2.png](../manuscripts/lpis%20map2.png)


---

## Figure 2: Average collisions by intersection type
![graph_of_time_trend_average_small.png](../manuscripts/graph_of_time_trend_average_small.png)

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

![choroplethmap_collisions.png](../manuscripts/choroplethmap_collisions.png)

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
## Identification Strategy
Difference-in-difference (DiD) quasi-experimental research design

$$ y_{it} = \alpha_i + \alpha_t + \beta^{DD}D_{it} + e_{it} $$

where dummies for the cross sectional intersections $\alpha_i$ and time periods $\alpha_t$, and a treatment dummy $D_{it}$. The treatment dummy, $D_{it} = 1$ indicates LPIs treatment was implemented at time period $t$ and treatment continues for the periods after, otherwise $D_{it} = 0$.  $e_{it}$ is the error term that is uncorrelated with $D_{it}$ and  $\alpha_t$.

---
## Goodman-Bacon’s general binary treatment difference-in-difference model
* There are 12,987 intersections $i$ and 25 periods $t$.
* Simplifying from 25 quarters, we can think of it as there being 3 different groups
    * untreated group $U$
    * early treatment group $k$ that receives treatment at $t^*_k$
    * late treatment group $l$ that receives treatment at $t^*_l$
* Intersections that received the LPIs intervention at a later period after $t^*_l$, hence in the periods before that, they act as controls to intersections that had received LPIs intervention at $t^*_k$

---

A simplfied representation of the model:


$$ \hat{\beta}_{jU}^{2x2} \equiv  (\bar y_j^{POST(j)} - \bar y_j^{PRE(j)}) - (\bar y_U^{POST(j)} - \bar y_U^{PRE(j)}), j=k,\ell. $$

My model is an extension to the simplfied model described above, and it is more complicated as it follows LPIs that were implemented across 25 quarters.

---
## Assumptions
* Unmeasured determinants of the outcomes were time invariant or group invariant
* Common trends assumption
* Timing of the treatment implementation “must be statistically independent of the potential outcomes distributions, conditional on the group-and time-fixed effects

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

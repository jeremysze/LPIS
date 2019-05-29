<!-- $theme: default -->

<!-- page_number: true -->

Hi Everyone, Thank you for coming to listen to my evaluation of the Impact of Leading pedestrian interval signal in New york city. I am Jeremy Sze and I am a graduate of Hunter College at the City University of New York. 

---
# Introduction

---
Reducing motor vehicle crash deaths was one of the great public health achievements of the 20th century for the US. 

Still, more than 32,000 people are killed and 2 million are injured each year from motor vehicle crashes

Vision Zero is an intiative to help end traffic deaths and injuries on New York City streets. Began in 2014. 

There are numerous programs in place. 

The one that I am studying is the Leading Pedestrian interval signal, LPIs in short.

---
LPIs is an intervention is applied at signalized intersection, which gives a head start to Pedestrians to cross. As you can see here, pesdestrians can cross first. Then the cars.
- There are about 2,700 LPIs intersections in NYC.
- As far as I am aware, this is the first large-scale impact evaluation study of LPIs.
---
Map of LPIs in 2013 and in 2015.

---
- Our outcomes comes from the NYPD motor vehicle collision dataset that is publicly available.

- We have location data, time, vehicle type and contributing factors. But we dont have socio-demographic/road characteristics, weather, etc.

- We also stratified the data by late night and non-late night to explore the effectiveness of LPIs in these settings. 

Next we will take a look at the data.

---
Here, we can see the plot of daily collisions in NYC.

---
Next, we can see the stratification of the collision data. The green starts are collisions that occured from 11.00pm to 4.59am. The blue diamonds are vice versa. 

---
Here we see the number of persons injured. Peaks in the summer.

---
Here, we see the number of pedestrians injured. Seems to peak in the winter periods.

---
Here, we see the number of cyclist injured. It is very seasonal. Peaks in the summer.

---
Here, we see a similar story with number of motorist injured.

---
Overlaid on top of each other we can see how they all come together.

---
Putting the two (outcomes and intervention) together, we can see that LPIs ever intersections have more collisions than LPIs never intersections.

---
I hypothesize that LPIs reduced collisions in injuries. But there are challengers

---
## Challenges and Solutions

---
## Selective implementation
Here we can see that the green dots (LPIs) intersections mostly fall on the dark redish brown portions of the map.

---
## Phased intersections
2013 and 2014

---
2015 and 2016

---
2017 and 2018

---
## Unobserved Heterogeneity
Things that make an intersections safer or more dangerous.

---
## Spatial Autocorrelation
[click]

---
- The degree to which one object is similar to other nearby objects. 
- similar values cluster together in a map

---
- We use a difference-in-difference design
- with variation in treatment timing
- simplfying from 25 quarters
- think of 3 groups
- control
- early treatment
- late treatment

---
- This visualization shows what I described. 
- The intersections that receive late treatment (after $t^*_l$) or are untreated become the controls for the early treatment group ($t^*_k$). 
- My model is an extension of that and it follows LPIs that were implemented across 25 quarters.

---
We rely on few assumptions in order to make causal inference of the effect of the LPIs treatment. 
1. Unmeasured determinants were time and group invariant
2. Common trends assumption
3. Timing of the treatment implementation is independent of the potential outcomes distributions

---
## Results!

---
Here we have the model specifications.
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
- Looking at the native collision results (without fixed effects)
- obviously we SHOULD NOT conclude from this that LPIS is raising the collision rate dramatically! 
- so what is going on?"
- Well .. it's obvious we need to think about and control for the observed and unobserved characteristics of intersections that explain where collisions occur and where LPIS are being targeted
- One also has to worry about downward trends and other interventions
- My regression framework sweeps out intersection fixed effects and controlling for observable time-varying variables

---
Putting these estimates into perspective.
- Average of 5% decrease in collisions each quarter
- 9.5% decrease in persons injured
- 14% decrease in pedestrians injured
- 8% decrease in motorist injured
- no change for cyclist

Robustness checks
- the drop in 2016 due to missing coordinates
- decay effect (1 year on, and 2 or more on)

---
Here in the late night model, we find that LPIs is not signficant across the different outcomes. Which tells us that perhaps LPIs is not effective during those hours. Perhaps we should switch off the LPIs during those times. Less time wasted.

---
In the non-late night hours, we find the effects of similar magnitudes to the pooled models.

---
Finally, as an additional interest of mine.
- explored a spatial lagged model just for manhattan
- computing limitation (64gb of ram just not enough)
- We calculate a queen spatial contiguity matrix (very intensive in Stata)
- Imagine a collision that occurs in one intersection causing a slow down
- there could be careless drivers in the intersection behind that follows to closely to the cars ahead. Another collision happens
- Here we find that there is a reduction for cyclist injured

---
Putting these into perspective. We see large impacts on pedestrians and cyclists. 

## I would like to extent my analysis
- Spatial analysis for the entire 5 boroughs
- Investigate further the number of motorist injured outside of manhattan.

---
Questions? And Thank you!
Please feel free to email me with questions, you can also find my thesis documentation on my github io page.

---
## Economic impact

- Back of the envelope calculations, the investment made by DOT is about 3.2 million
- The Federal Highway administration report has estimates of the cost of a collision. 
Using the predicted values from , 4,609 persons avoided injuries.
- Which translates to 12 million in human capital cost avoided.




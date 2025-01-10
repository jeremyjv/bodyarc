
export const frontAnalysis = `
This is my current physique. For the muscles that you see in the image, if the muscle is completely not shown in the image leave the rating and description as null. Even if you see a small portion of the muscle in the image, still include a full analysis of it. For example, only a portion of the leg may be showing, but the calf muscle may still be showing. A muscle must be completely covered in clothing to be dismissed from the analysis. 
In the following JSON Format:
{
    "bodyFatPercentage": Int,
    "shoulders": Int,
    "chest": Int,
    "abs": Int,
    "arms": Int,
    "clavicleWidth": String,
    "waistSize": String,
    "vTaper": Int, 
    "overall": Int,
    "potential": Int,
    "bodyType": String,
    
  
}
give me:
1) A Rating on a scale of 1-100 for the Body Fat Percentage where 100 indicates the most lean and a lower rating indicates a fatter body. A softer look in the body indicates a higher body fat percentage and a more defined look where you can see muscle definition indicates a lower body fat percentage:
2) A Rating on a scale of 1-100 for the shoulder development. Developed shoulders should contribute to the width of the upper body and be well defined. And attach a description of why you gave the specific rating.
3) A Rating on a scale of 1-100 for the chest development. A developed chest should appear full and round, not flat. Distinguish these features for the upper chest, mid chest, and lower chest. And attach a description of why you gave the specific rating.
4) A Rating on a scale of 1-100 for the Ab development. Developed abs should have multiple lines and appear to be sticking out. A softer look in the abs indicates a higher body fat percentage and therefore lower score. And attach a description of why you gave the specific rating.
5) A Rating on a scale of 1-100 for the Arm development. A developed arm should have a bicep that contributes to the width of the arm. If there is a vein on the bicep that signals even better development. And attach a description of why you gave the specific rating.
6) A size of the clavicle width from the list [Short, Medium, Wide]
7) The size of the waist from the list: [Wide, Medium, Narrow]
8) A Rating on a scale of 1-100 for the V-Taper of the body
9) The overall average of all the scores
10) potential is just adding 5 to the overall score and clamp the number to 100 in case it goes over
11) the body type of the individual from the list: [Endomorph, Ectomorph, Mesomorph]

`


export const backAnalysis = `
This is my current physique. For the muscles that you see in the image, if the muscle is completely not shown in the image leave the rating and description as null. Even if you see a small portion of the muscle in the image, still include it in the analysis. A muscle must be completely covered in clothing to be dismissed from the analysis. The glute muscle is the only exception to still give a rating even when it is covered with clothing.  
In the following JSON Format:
{
    "traps": Int,
    "lats": Int,
    "rearDelts": Int,
    "lowerBack": Int,
    "latInsertion": String,
    "density": String,
    "width": String
    

}
give me:

 1) A Rating on a scale of 1-100 for the trapezius development. Developed traps should make the neck appear thicker, and contribute to the density of the back. And attach a description of why you gave the specific rating.
 2) A Rating on a scale of 1-100 for the latissimus dorsi. Developed lats should contribute to the width of the back and contribute to the V shape of the body. And attach a description of why you gave the specific rating.
 3) A Rating on a scale of 1-100 for the rearDelts. 
 4) A Rating on a scale of 1-100 for the lowerBack.
 5) A Rating from the list [High, Low] for the lat muscle insertion on the back
 6) A Rating from the list [Shallow, Moderate, Thick] for the density of the back
 7) A Rating from the list [Narrow, Medium, Wide] for the width of the back


`




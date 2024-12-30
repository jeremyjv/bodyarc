
export const frontAnalysis = `
This is my current physique. For the muscles that you see in the image, if the muscle is completely not shown in the image leave the rating and description as null. Even if you see a small portion of the muscle in the image, still include a full analysis of it. For example, only a portion of the leg may be showing, but the calf muscle may still be showing. A muscle must be completely covered in clothing to be dismissed from the analysis. 
 In JSON Format give me:
1) The Overall Body Fat Percentage, and give me an exact number. A softer look in the body indicates a higher body fat percentage and a more defined look where you can see muscle definition indicates a lower body fat percentage:
2) A Rating on a scale of 1-100 for the shoulder development. Developed shoulders should contribute to the width of the upper body and be well defined. And attach a description of why you gave the specific rating.
3) A Rating on a scale of 1-100 for the chest development. A developed chest should appear full and round, not flat. Distinguish these features for the upper chest, mid chest, and lower chest. And attach a description of why you gave the specific rating.
4) A Rating on a scale of 1-100 for the Ab development. Developed abs should have multiple lines and appear to be sticking out. A softer look in the abs indicates a higher body fat percentage and therefore lower score. And attach a description of why you gave the specific rating.
5) A Rating on a scale of 1-100 for the Arm development. A developed arm should have a bicep that contributes to the width of the arm. If there is a vein on the bicep that signals even better development. And attach a description of why you gave the specific rating.
6) A Rating on a scale of 1-100 for the Quad development. A developed quad should have a should have the “teardrop” look and have visible separation between the different muscles of the quadricep
7) A Rating on a scale of 1-100 for the Calve development. A developed calve should have a decent amount of width, but not wider than the quad.
`


export const backAnalysis = `
This is my current physique. For the muscles that you see in the image, if the muscle is completely not shown in the image leave the rating and description as null. Even if you see a small portion of the muscle in the image, still include it in the analysis. A muscle must be completely covered in clothing to be dismissed from the analysis. The glute muscle is the only exception to still give a rating even when it is covered with clothing.  
 In JSON Format give me:
 1) The Overall Body Fat Percentage, and give me an exact number. A softer look in the body indicates a higher body fat percentage and a more defined look where you can see muscle definition indicates a lower body fat percentage:
 2) A Rating on a scale of 1-100 for the trapezius development. Developed traps should make the neck appear thicker, and contribute to the density of the back. And attach a description of why you gave the specific rating.
 3) A Rating on a scale of 1-100 for the latissimus dorsi. Developed lats should contribute to the width of the back and contribute to the V shape of the body. And attach a description of why you gave the specific rating.
 4) A Rating on a scale of 1-100 for the gluteus maximus. Developed glutes should appear round and contribute to the thickness of the hips
 5) A Rating on a scale of 1-100 for the Quad development. A developed quad should have a should have the “teardrop” look and have visible separation between the different muscles of the quadricep
 6) A Rating on a scale of 1-100 for the Calve development. A developed calve should have a decent amount of width, but not wider than the quad.

`




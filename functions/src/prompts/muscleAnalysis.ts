
export const frontAnalysis = `
This is my current physique. For the muscles that you see in an image, I'm going to ask you to rate each muscle based on its development. If you can't see a muscle rate it as 0, but it's unlikely you won't be able to see it. 
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
1) A Rating on a scale of 1-100 for the Body Fat Percentage where 100 indicates the most lean and a lower rating indicates a fatter body. A softer look in the body indicates a higher body fat percentage and a more defined look where you can see muscle definition indicates a lower body fat percentage. Remember don't give me the actual body fat percentage, but a rating of 1-100. 
2) A Rating on a scale of 1-100 for the shoulder development. Developed shoulders should contribute to the width of the upper body and be well defined. A should is well defined if there is clear separation between the deltoid muscles and the arm muscles
3) A Rating on a scale of 1-100 for the chest development. A developed chest should appear full and round, not flat. The upper chest should show visible fullness and not appear flat for a higher score. The lower chest should not appear flat, and should be well defined and rounded.
4) A Rating on a scale of 1-100 for the Ab development. Developed abs should have multiple lines and appear to be sticking out. A softer look in the abs indicates a higher body fat percentage and therefore lower score. 
5) A Rating on a scale of 1-100 for the Arm development. Developed arms should have a bicep that contributes to the width of the arm, and an even higher score if the tricep is visible. If there is a vein on the bicep that signals even better development. And attach a description of why you gave the specific rating.
6) A size of the clavicle width from the list: [Narrow, Medium, Wide]. A narrow clavicle width means that the individual naturally has very narrow shoulders. A medium clavicle width means that the individual naturally has wider clavicle bones which helps contribute to the width of the shoulders (this should be the most common amongst the average person). A wide clavicle width means that the individual has very long collar bones meaning that their shoulders contribute disproportionate width to their upper body (this will be most common in more fit and healthy individuals)
7) The size of the waist from the list: [Wide, Medium, Narrow]. A wide waist means that there is little to no v-taper from the upper body to the lower body, and their torso looks uniform top to bottom, this rating will be most common for unfit individuals or individuals that have overdeveloped obliques. A medium waist means that the waist is more narrow than the shoulders and there is some taper from the upper part of the torso to the lower part of the torso (this will be most common for the average person). A narrow waist indicates a very fit individual with a low body fat percentage, and the taper from their upper torso to their lower torso is very significant (this will be the most common amongst individuals that have a low body fat percentage and developed shoulders)
8) A Rating on a scale of 1-100 for the V-Taper of the body. Your rating should be based on steps 6 and 7 where Wide Clavicle and Narrow waist is the highest score and Narrow clavicle and Wide waist is the lowest score. 
9) The overall average of all the scores
10) potential is just adding 5 to the overall score and clamp the number to 100 in case it goes over
11) The body type of the individual from the list: [Endomorph, Ectomorph, Mesomorph]. Endomorphs have softer bodies with curves. They have a wide waist and hips and large bones, though they may or may not be overweight. Their weight is often in their hips, thighs, and lower abdomen. Endomorphs often have lots of body fat and muscle and tend to gain weight easily.Ectomorph describes a body type that is tall and slim, with narrow shoulders and a low muscle mass percentage. Muscular build, Broad shoulders and narrow hips, Strong bones, Low body fat percentage, and Athletic appearance.


`


export const backAnalysis = `
This is my current physique. For the muscles that you see in an image, I'm going to ask you to rate each muscle based on its development. If you can't see a muscle rate it as 0, but it's unlikely you won't be able to see it. 
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

1) A Rating on a scale of 1-100 for the trapezius development. Developed traps should make the neck appear thicker, and contribute to the density of the back. The traps should also contribute to the aesthetic of the back by having well defined traps that “pop” out that contribute to the lines of the back. 
2) A Rating on a scale of 1-100 for the latissimus dorsi. Developed lats should contribute to the width of the back and contribute to the V shape of the body. The lats also contribute to the aesthetic of the back when it is well defined you can see the striations of the muscles which add more lines to the back giving it a more aesthetic look
3) A Rating on a scale of 1-100 for the rear delts. Developed rear delts are important because it makes the upper back look less flat. Developed rear delts should pop and have visible separation from the traps and lats. It should look like the rear delt muscle is wrapping around the shoulder and back. 
4) A Rating on a scale of 1-100 for the lowerBack. A developed lower back includes thick spinal erectors. This will be more visible on leaner individuals that have high overall back development
5) A Rating from the list [High, Low] for the lat muscle insertion on the back. A high lat insertion means that the taper of the back starts higher than usual because the lat muscle is attached higher on the back. (this will be more common with individuals that have a visible narrow waist from the back view). A low lat insertion means that the taper starts lower on the back because the lat muscle is attached lower on the back, this will be more common for individuals that have a wider waist appearance from the back view
6) A Rating from the list [Shallow, Moderate, Thick] for the density of the back. A shallow back means that there is little to no muscle development in the muscle overall, often meaning there are no lines and the back appears flat. A moderate back means that there is some development but there is some improvement in growth to be made. A thick back means that the muscles of the back pop out and do not appear flat. This is apparent when the traps, spinal erectors, and rear delts pop out (This will be most common for individuals that have a wider and 3D look to their back)
7) A Rating from the list [Narrow, Medium, Wide] for the width of the back. A narrow back indicates little to no back development and the back has no taper from the upper body to the waist. A medium width back indicated some development in definition and size but there is more potential in growth to be made. A wide back means that there is significant taper from the upper torso the the lower torso (this will be most common in fit individuals that have a well defined back and overall back development)



`




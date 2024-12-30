

////OPEN API SHIT
import { OpenAI } from 'openai';  // Import the OpenAI class from the 'openai' package
import { OPENAI_API_KEY } from '../services/config';
import { frontAnalysis, backAnalysis } from '../prompts/muscleAnalysis';

// Initialize the OpenAI API client with your API key
const openai = new OpenAI({
  apiKey: OPENAI_API_KEY,
  // You can optionally specify other parameters here (e.g., base URL, headers, etc.)
});

const muscleList = ["deltoids", "pectoralis", "biceps", "trapezius", "latissimus dorsi", "calves", "erector spinae", "gluteus maximus"]
//gpt4o mini to find muscles
export const findMusclesInImage = async (base64_image: string): Promise<string> => {
  try {
    const response = await openai.chat.completions.create({
      model:"gpt-4o-mini",
      messages:[
        {
          "role": "user",
          "content": [
            {
              "type": "text",
              "text": `from the list ${muscleList} give me a list in JSON of all the muscles you see in this image named visibleMuscles. 
              You should list the muscle even if you see a small sliver of it in the image. You should not list the muscle if you do not see the skin of that muscle`,
            },
            {
              "type": "image_url",
              "image_url": {
                "url":  `data:image/jpeg;base64,${base64_image}`
              },
            },
          ],
        }
      ],
  });
    // Return the generated text
    return response.choices[0]?.message?.content?.trim() || '';
  } catch (error) {
    console.error('OpenAI API error:', error);
    throw new Error('Failed to generate text');

  }
};

export const generateTextFromText = async (prompt: string): Promise<string> => {
  try {
    // Request to generate a completion using the OpenAI API


    const response = await openai.chat.completions.create({
    model: "gpt-4o-mini",
    messages: [
        { role: "system", content: "You are a body scanner." },
        {
            role: "user",
            content: prompt,
        },
    ],
});

    // Return the generated text
    return response.choices[0]?.message?.content?.trim() || '';
  } catch (error) {
    console.error('OpenAI API error:', error);
    throw new Error('Failed to generate text');
  }
};
//let text1 = "Give a rating 1-10 for each muscle group based on the following criteria: body fat percentage, development of muscle, and proportion of muscle in respect to the entire body optimizing for a v-shape look"
//let text2 = "estimate my body fat percentage and give me a reason for your guess in less than 500 characters"
export const generateFrontAnalysisFromImage = async (base64_image: string): Promise<string> => {
  try {
    // Request to generate a completion using the OpenAI API
    //This is my current body physique, can you analyze the different muscles on my body, what is good, and what I can improve. And can you also guess what my body fat percentage is?
    const response = await openai.chat.completions.create({
      model:"gpt-4o",
      messages:[
        {
          "role": "assistant",
          "content": [
            {
              "type": "text",
              "text": "you are an objective body scanner that analyses body images"
            }
          ]
        },
        {
          "role": "user",
          "content": [
            {
              "type": "text",
              "text": frontAnalysis,
            },
            {
              "type": "image_url",
              "image_url": {
                "url":  `data:image/jpeg;base64,${base64_image}`
              },
            },
          ],
        }
      ],
      response_format:{
        "type": "json_object"
      },
  });
      // Return the generated text
      return response.choices[0]?.message?.content?.trim() || '';

} catch (error) {
    console.error('OpenAI API error:', error);
    throw new Error('Failed to generate text');
  }
};


export const generateBackAnalysisFromImage = async (base64_image: string): Promise<string> => {
  try {
    // Request to generate a completion using the OpenAI API
    //This is my current body physique, can you analyze the different muscles on my body, what is good, and what I can improve. And can you also guess what my body fat percentage is?
    const response = await openai.chat.completions.create({
      model:"gpt-4o",
      messages:[
        {
          "role": "assistant",
          "content": [
            {
              "type": "text",
              "text": "you are an objective body scanner that analyses body images"
            }
          ]
        },
        {
          "role": "user",
          "content": [
            {
              "type": "text",
              "text": backAnalysis,
            },
            {
              "type": "image_url",
              "image_url": {
                "url":  `data:image/jpeg;base64,${base64_image}`
              },
            },
          ],
        }
      ],
      response_format:{
        "type": "json_object"
      },
  });
      // Return the generated text
      return response.choices[0]?.message?.content?.trim() || '';

} catch (error) {
    console.error('OpenAI API error:', error);
    throw new Error('Failed to generate text');
  }
};
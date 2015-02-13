// LMR :
// L - length from light
// M - normal matching with light
// R - reflection matching with eye

vec3 lightLMR( vec3 lig , vec3 pos , vec3 nor ,  vec3 eye  ){

 	vec3 light = normalize( pos - lig );
 	
  float lightLength = length( pos - lig );
    
  vec3 refl = reflect( light , nor );

  float lightMatch = max( 0. , dot( -light , nor ));
  float reflMatch =  max( 0. , dot( normalize(eye) , refl) );


  return vec3( lightLength , lightMatch , reflMatch );


}

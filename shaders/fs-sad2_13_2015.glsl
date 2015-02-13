
uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

const int STEPS = 100;
const float PRECISION = .001;
const float MAX_DISTANCE = 10.;

const int numOfLights = 5;

vec3 lightPos[  numOfLights ];
vec3 lightCols[ numOfLights ];

$opU

vec2 sphereSD( vec3 pos , vec3 sPos ,  float r , float id ){

  float dist = length( pos - sPos ) - r;
  return vec2( dist , id );

}

vec2 iSphereSD( vec3 pos , vec3 sPos ,  float r , float id ){

  float dist = r - length( pos - sPos );
  return vec2( dist , id );

}



vec2 lightMaps( vec2 r , vec3 pos ){

  vec2 res = r;
      
  for( int i = 0; i < numOfLights; i++ ){

   // float r = .1;
    vec2 res2 = sphereSD( pos , lightPos[i] , .1 , 10. + float(i) );
  
    res = opU( res , res2 ); 
      
  }
     

  return res;

}

//--------------------------------
// Modelling 
//--------------------------------
vec2 map( vec3 pos ){  
    
  vec2 res = vec2( length( pos ) - 1.   , 0. );

  res = lightMaps( res , pos  );

  return res;
    
}

vec2 mapRefract( vec3 pos ){  
    
  vec2 res = vec2( length( pos ) - .3   , 0. );

  return res;
    
}


/*

  LIGHTING

*/
$lightLMR



// Calc UTIL functions
$calcLookAtMatrix
$calcNormal
$calcIntersection
$calcRefract



void doCamera( out vec3 camPos, out vec3 camTar, in float time, in float mouseX ){

    float an = 5.0*(-mouseX);

	  camPos = vec3(  an , 0. , 3.);
    camTar = vec3(0.0, sin( time * .1 ) * .3 ,0.0);
}

void doBackground(){

}

void main(){

  for( int i = 0; i < numOfLights; i++ ){

    float x = 2. * sin(time * 1. + float(i) ) ;
    float y = 2. * cos(time * 1. + float(i) ) ;
    float z = 0.; 
    lightPos[i] = vec3( x , y , z );
    lightCols[i] = normalize( lightPos[i] ) * .5 + .5;

  }

  
  vec2 p = (resolution.xy -  2. *gl_FragCoord.xy)/resolution.y;
  vec2 m = mouse.xy/resolution.xy;

  // camera movement
  vec3 ro, ta;
  doCamera( ro, ta, time , m.x);

  mat3 camMat = calcLookAtMatrix( ro, ta, 0.0 );  // 0.0 is the camera roll

  vec3 rd = normalize( camMat * vec3(p.xy,2.0) ); // 2.0 is the lens length

  vec2 res = calcIntersection( ro , rd , PRECISION , MAX_DISTANCE  );
 
  vec3 col = vec3( 0. , 0. , 0. ); 
   
  // If we have hit something lets get real!
  if( res.y > -.5 ){

    vec3 pos = ro + rd * res.x;
    vec3 nor = calcNormal( pos );

  
    if( res.y == 0. ){
    
    for( int i = 0; i< numOfLights; i++ ){
    
      vec3 lmr = lightLMR( lightPos[i] , pos , nor , ro  );

      col += pow( lmr.z , 50. ) * lightCols[i];
      col += pow( lmr.y , 2. ) * lightCols[i];
      
     // col = (nor * .5 + .5) * .3;
      vec3 dir = normalize(pos - lightPos[i]);

      vec3 refr = refract( dir , nor , .8 );


      vec2 center = calcRefract( pos - refr * .01 , refr , PRECISION , MAX_DISTANCE  );


      col += (refr * .5 + .5)  * .1;

      if( center.y > -.5 ){
      //vec3
        col = max( vec3( 0. ) , col - nor * .5 - .5);

      }



 
    }


    }else if( res.y >= 10. ){

      for( int i = 0; i< numOfLights; i++ ){
        if( float( i ) == res.y - 10. ){
          col = lightCols[i];
        }
      }
      

    }

   // col = vec3( 1. );//vec3( max( 0. , dot( nor ,normalize(pos - vec3( 1. , 0. , 0. )))));//vec3( 1. );

  }else{

  }

  // apply gamma correction
  col = pow( col, vec3(0.4545) );

  gl_FragColor = vec4( col , 1. );

}

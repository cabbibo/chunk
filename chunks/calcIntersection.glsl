vec2 calcIntersection( vec3 ro , vec3 rd , float pre , float maxDist ){

    
  float h =  pre * 2.0;
  float t = 0.0;
	float res = -1.0;
  float id = -1.;
  
  for( int i = 0; i < STEPS; i++ ){
      
      if( h < pre || t > maxDist ) break;
      vec2 m = map( ro+rd*t );
      h = m.x;
      t += h;
      id = m.y;
      
  }

  if( t < maxDist ) res = t;
  if( t > maxDist ) id =-1.0;
  
  return vec2( res , id );
    
}

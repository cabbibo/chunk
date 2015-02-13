mat3 calcLookAtMatrix( in vec3 camPos, in vec3 targetPos, in float roll ){

  vec3 ww = normalize( targetPos - camPos );
  vec3 uu = normalize( cross( ww , vec3( sin( roll ) , cos( roll ) , 0.0 ) ) );
  vec3 vv = normalize( cross( uu , ww ) );
  return mat3( uu , vv , ww );

}

Shader "Saberslay Shaders/Screen/Fade Screen"
{
	Properties
	{
		_Colorspeed("Color speed", Range( 0 , 1)) = 0.2
		_Light("Light", Range( -1 , 1)) = 1
		_color("color ", Range( -1 , 1)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}
	
	SubShader
	{
		Tags{ "RenderType" = "Overlay"  "Queue" = "Overlay+10000" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		ZTest Always
		Offset  0 , 0
		Blend SrcAlpha OneMinusSrcAlpha
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 screenPos;
		};

		uniform float _Colorspeed;
		uniform float _Light;
		uniform float _color;
		uniform sampler2D _GrabTexture;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime8 = _Time.y * _Colorspeed;
			float3 hsvTorgb10 = HSVToRGB( float3(mulTime8,_Light,_color) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor2 = tex2D( _GrabTexture, ase_grabScreenPosNorm.xy );
			float4 blendOpSrc4 = float4( hsvTorgb10 , 0.0 );
			float4 blendOpDest4 = screenColor2;
			o.Emission = ( saturate( (( blendOpDest4 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest4 - 0.5 ) ) * ( 1.0 - blendOpSrc4 ) ) : ( 2.0 * blendOpDest4 * blendOpSrc4 ) ) )).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "Saberslay"
}
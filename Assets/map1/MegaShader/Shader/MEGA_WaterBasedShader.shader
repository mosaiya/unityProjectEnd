// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MEGA_WaterBasedShader"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_TessellationMultiplier("TessellationMultiplier", Range( 0.1 , 50)) = 0
		_Master_MetalnessAdd("Master_MetalnessAdd", Range( 0 , 1)) = 1
		_Master_GlossAdd("Master_GlossAdd", Range( 0 , 1)) = 1
		_BaseLayerMix("Base-LayerMix", Range( 0 , 1)) = 1
		[Toggle(_USESSMOOTHNESS_ON)] _UsesSmoothness("UsesSmoothness", Float) = 0
		[NoScaleOffset]_RGBNoisemap("RGB-Noisemap", 2D) = "white" {}
		_RGBMask_Tiling("RGBMask_Tiling", Range( 0.5 , 10)) = 0.5
		[NoScaleOffset]_BaseAlbedoCutout("Base-Albedo/Cutout", 2D) = "white" {}
		[NoScaleOffset]_BaseMetalGlossAOHeightA("Base-Metal/Gloss/AO/Height(A)", 2D) = "white" {}
		[NoScaleOffset]_BaseNormalMap("Base-NormalMap", 2D) = "bump" {}
		_BaseColor("BaseColor", Color) = (1,1,1,1)
		_BaseTiling("Base-Tiling", Range( 0.5 , 10)) = 0.5
		_BaseHeightBoost("BaseHeightBoost", Range( 0 , 50)) = 1
		_BaseHeightOffset("BaseHeightOffset", Range( -5 , 5)) = 0
		[NoScaleOffset]_Masked1AlbedoCutout("Masked1-Albedo/Cutout", 2D) = "white" {}
		[NoScaleOffset]_Masked1MetalGlossAOHeightA("Masked1-Metal/Gloss/AO/Height(A)", 2D) = "white" {}
		[NoScaleOffset][Normal]_Masked1NormalMap("Masked1-NormalMap", 2D) = "bump" {}
		_Masked1ColorLayerAmount("Masked1Color/LayerAmount", Color) = (1,1,1,1)
		_Masked1Tiling("Masked1-Tiling", Range( 0.5 , 10)) = 0.5
		_Masked1HeightBoost("Masked1HeightBoost", Range( 0 , 50)) = 1
		_Masked1HeightOffset("Masked1HeightOffset", Range( -5 , 5)) = 0
		[NoScaleOffset]_Masked2AlbedoCutout("Masked2-Albedo/Cutout", 2D) = "white" {}
		[NoScaleOffset]_Masked2MetalGlossAOEmisHeightA("Masked2-Metal/Gloss/AO-Emis/Height(A)", 2D) = "white" {}
		[NoScaleOffset]_Masked2NormalMap("Masked2-NormalMap", 2D) = "bump" {}
		_Masked2ColorLayerAmount("Masked2Color/LayerAmount", Color) = (1,1,1,1)
		_Masked2Tiling("Masked2-Tiling", Range( 0.5 , 10)) = 0.5
		_Masked2HeightBoost("Masked2HeightBoost", Range( 0 , 50)) = 1
		_Masked2HeightOffset("Masked2HeightOffset", Range( -5 , 5)) = 0
		[Toggle(_TREAT_AO_AS_EMISSIVE_ON)] _Treat_AO_as_Emissive("Treat_AO_as_Emissive", Float) = 0
		[Toggle(_INVERT_AO_ON)] _Invert_AO("Invert_AO", Float) = 0
		_WaterColorMuddyness("WaterColor/Muddyness", Color) = (0.1706855,0.236529,0.3014706,0)
		_WaterMetallicGloss("Water- Metallic-Gloss", Vector) = (0.2,0.8,0,0)
		_WaterHeightLevel("WaterHeightLevel", Range( -2 , 10)) = 0.2
		_WaterTiling("WaterTiling", Float) = 2
		_WaterTurbulence("WaterTurbulence", Range( 0 , 1)) = 0.3
		_RefractionAmount("RefractionAmount", Range( 0 , 1)) = 0.2
		[NoScaleOffset]_WaterRippleNormalMap2("WaterRipple-NormalMap2", 2D) = "bump" {}
		[NoScaleOffset]_WaterRippleNormalMap1("WaterRipple-NormalMap1", 2D) = "bump" {}
		_NoiseTilingMaster("NoiseTilingMaster", Range( 0.1 , 2)) = 1
		_NoiseMod1("NoiseMod1", Range( 0 , 2)) = 0.1
		_NoiseMod2("NoiseMod2", Range( 0 , 2)) = 0.1
		_NoiseMod3("NoiseMod3", Range( 0 , 2)) = 0.1
		_NoiseLerper("NoiseLerper", Range( 0 , 2)) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#pragma shader_feature _TREAT_AO_AS_EMISSIVE_ON
		#pragma shader_feature _INVERT_AO_ON
		#pragma shader_feature _USESSMOOTHNESS_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
			INTERNAL_DATA
		};

		uniform sampler2D _BaseMetalGlossAOHeightA;
		uniform float _BaseTiling;
		uniform float _BaseHeightBoost;
		uniform float _BaseHeightOffset;
		uniform sampler2D _Masked1MetalGlossAOHeightA;
		uniform float _Masked1Tiling;
		uniform float _Masked1HeightBoost;
		uniform float _Masked1HeightOffset;
		uniform sampler2D _RGBNoisemap;
		uniform float _RGBMask_Tiling;
		uniform float _NoiseMod1;
		uniform float _NoiseTilingMaster;
		uniform float _NoiseMod2;
		uniform float _NoiseLerper;
		uniform float _BaseLayerMix;
		uniform float4 _Masked1ColorLayerAmount;
		uniform sampler2D _Masked2MetalGlossAOEmisHeightA;
		uniform float _Masked2Tiling;
		uniform float _Masked2HeightBoost;
		uniform float _Masked2HeightOffset;
		uniform float _NoiseMod3;
		uniform float4 _Masked2ColorLayerAmount;
		uniform float _WaterHeightLevel;
		uniform sampler2D _BaseNormalMap;
		uniform float _RefractionAmount;
		uniform sampler2D _WaterRippleNormalMap1;
		uniform float _WaterTiling;
		uniform sampler2D _WaterRippleNormalMap2;
		uniform float _WaterTurbulence;
		uniform sampler2D _Masked1NormalMap;
		uniform sampler2D _Masked2NormalMap;
		uniform float4 _BaseColor;
		uniform sampler2D _BaseAlbedoCutout;
		uniform sampler2D _Masked1AlbedoCutout;
		uniform sampler2D _Masked2AlbedoCutout;
		uniform float4 _WaterColorMuddyness;
		uniform float2 _WaterMetallicGloss;
		uniform float _Master_MetalnessAdd;
		uniform float _Master_GlossAdd;
		uniform float _TessellationMultiplier;
		uniform float _Cutoff = 0.5;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, 10.0,50.0,_TessellationMultiplier);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertexNormal = v.normal.xyz;
			float2 temp_cast_0 = (_BaseTiling).xx;
			float2 uv_TexCoord269 = v.texcoord.xy * temp_cast_0;
			float4 tex2DNode2 = tex2Dlod( _BaseMetalGlossAOHeightA, float4( uv_TexCoord269, 0, 0.0) );
			float2 temp_cast_1 = (_Masked1Tiling).xx;
			float2 uv_TexCoord270 = v.texcoord.xy * temp_cast_1;
			float4 tex2DNode6 = tex2Dlod( _Masked1MetalGlossAOHeightA, float4( uv_TexCoord270, 0, 0.0) );
			float2 temp_cast_2 = (_RGBMask_Tiling).xx;
			float2 uv_TexCoord544 = v.texcoord.xy * temp_cast_2;
			float4 tex2DNode60 = tex2Dlod( _RGBNoisemap, float4( uv_TexCoord544, 0, 0.0) );
			float temp_output_77_0 = ( tex2DNode60.r * _NoiseMod1 * _NoiseTilingMaster );
			float2 appendResult129 = (float2(temp_output_77_0 , temp_output_77_0));
			float simplePerlin2D44 = snoise( appendResult129 );
			float clampResult39 = clamp( simplePerlin2D44 , 0.0 , 1.0 );
			float temp_output_86_0 = ( tex2DNode60.g * _NoiseMod2 * _NoiseTilingMaster );
			float2 appendResult130 = (float2(temp_output_86_0 , temp_output_86_0));
			float simplePerlin2D90 = snoise( appendResult130 );
			float clampResult85 = clamp( simplePerlin2D90 , 0.0 , 1.0 );
			float lerpResult110 = lerp( clampResult39 , clampResult85 , _NoiseLerper);
			float lerpResult209 = lerp( 0.0 , lerpResult110 , _BaseLayerMix);
			float clampResult306 = clamp( ( lerpResult209 * _Masked1ColorLayerAmount.a ) , 0.0 , 1.0 );
			float Mask1_reg138 = clampResult306;
			float lerpResult363 = lerp( ( ( tex2DNode2.a * _BaseHeightBoost ) + _BaseHeightOffset ) , ( ( tex2DNode6.a * _Masked1HeightBoost ) + _Masked1HeightOffset ) , Mask1_reg138);
			float2 temp_cast_3 = (_Masked2Tiling).xx;
			float2 uv_TexCoord271 = v.texcoord.xy * temp_cast_3;
			float4 tex2DNode7 = tex2Dlod( _Masked2MetalGlossAOEmisHeightA, float4( uv_TexCoord271, 0, 0.0) );
			float temp_output_96_0 = ( tex2DNode60.b * _NoiseMod3 * _NoiseTilingMaster );
			float2 appendResult131 = (float2(temp_output_96_0 , temp_output_96_0));
			float simplePerlin2D100 = snoise( appendResult131 );
			float clampResult95 = clamp( simplePerlin2D100 , 0.0 , 1.0 );
			float lerpResult112 = lerp( clampResult85 , clampResult95 , _NoiseLerper);
			float lerpResult210 = lerp( 0.0 , lerpResult112 , _BaseLayerMix);
			float clampResult307 = clamp( ( lerpResult210 * _Masked2ColorLayerAmount.a ) , 0.0 , 1.0 );
			float Mask2_reg139 = clampResult307;
			float lerpResult364 = lerp( lerpResult363 , ( ( tex2DNode7.a * _Masked2HeightBoost ) + _Masked2HeightOffset ) , Mask2_reg139);
			float clampResult215 = clamp( lerpResult364 , _WaterHeightLevel , 100.0 );
			v.vertex.xyz += ( ase_vertexNormal * clampResult215 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_BaseTiling).xx;
			float2 uv_TexCoord269 = i.uv_texcoord * temp_cast_0;
			float temp_output_386_0 = (0.0 + (( _WaterHeightLevel + 2.0 ) - 0.0) * (1.0 - 0.0) / (12.0 - 0.0));
			float4 tex2DNode2 = tex2D( _BaseMetalGlossAOHeightA, uv_TexCoord269 );
			float2 temp_cast_3 = (_Masked1Tiling).xx;
			float2 uv_TexCoord270 = i.uv_texcoord * temp_cast_3;
			float4 tex2DNode6 = tex2D( _Masked1MetalGlossAOHeightA, uv_TexCoord270 );
			float2 temp_cast_4 = (_RGBMask_Tiling).xx;
			float2 uv_TexCoord544 = i.uv_texcoord * temp_cast_4;
			float4 tex2DNode60 = tex2D( _RGBNoisemap, uv_TexCoord544 );
			float temp_output_77_0 = ( tex2DNode60.r * _NoiseMod1 * _NoiseTilingMaster );
			float2 appendResult129 = (float2(temp_output_77_0 , temp_output_77_0));
			float simplePerlin2D44 = snoise( appendResult129 );
			float clampResult39 = clamp( simplePerlin2D44 , 0.0 , 1.0 );
			float temp_output_86_0 = ( tex2DNode60.g * _NoiseMod2 * _NoiseTilingMaster );
			float2 appendResult130 = (float2(temp_output_86_0 , temp_output_86_0));
			float simplePerlin2D90 = snoise( appendResult130 );
			float clampResult85 = clamp( simplePerlin2D90 , 0.0 , 1.0 );
			float lerpResult110 = lerp( clampResult39 , clampResult85 , _NoiseLerper);
			float lerpResult209 = lerp( 0.0 , lerpResult110 , _BaseLayerMix);
			float clampResult306 = clamp( ( lerpResult209 * _Masked1ColorLayerAmount.a ) , 0.0 , 1.0 );
			float Mask1_reg138 = clampResult306;
			float lerpResult363 = lerp( ( ( tex2DNode2.a * _BaseHeightBoost ) + _BaseHeightOffset ) , ( ( tex2DNode6.a * _Masked1HeightBoost ) + _Masked1HeightOffset ) , Mask1_reg138);
			float2 temp_cast_5 = (_Masked2Tiling).xx;
			float2 uv_TexCoord271 = i.uv_texcoord * temp_cast_5;
			float4 tex2DNode7 = tex2D( _Masked2MetalGlossAOEmisHeightA, uv_TexCoord271 );
			float temp_output_96_0 = ( tex2DNode60.b * _NoiseMod3 * _NoiseTilingMaster );
			float2 appendResult131 = (float2(temp_output_96_0 , temp_output_96_0));
			float simplePerlin2D100 = snoise( appendResult131 );
			float clampResult95 = clamp( simplePerlin2D100 , 0.0 , 1.0 );
			float lerpResult112 = lerp( clampResult85 , clampResult95 , _NoiseLerper);
			float lerpResult210 = lerp( 0.0 , lerpResult112 , _BaseLayerMix);
			float clampResult307 = clamp( ( lerpResult210 * _Masked2ColorLayerAmount.a ) , 0.0 , 1.0 );
			float Mask2_reg139 = clampResult307;
			float lerpResult364 = lerp( lerpResult363 , ( ( tex2DNode7.a * _Masked2HeightBoost ) + _Masked2HeightOffset ) , Mask2_reg139);
			float clampResult220 = clamp( ( _WaterHeightLevel - lerpResult364 ) , 0.0 , 1.0 );
			float WaterMasked368 = clampResult220;
			float temp_output_387_0 = ( sin( temp_output_386_0 ) * ( temp_output_386_0 * ( ( ( _RefractionAmount * temp_output_386_0 ) + _RefractionAmount ) * WaterMasked368 * WaterMasked368 ) ) );
			float3 _Vector2 = float3(0,0,1);
			float clampResult225 = clamp( _WaterHeightLevel , 0.0 , 2.0 );
			float temp_output_226_0 = ( clampResult225 * 0.1 );
			float2 temp_cast_6 = (_WaterTiling).xx;
			float2 uv_TexCoord135 = i.uv_texcoord * temp_cast_6;
			float2 panner133 = ( 1.0 * _Time.y * ( float2( 0.01,0.02 ) * temp_output_226_0 * _WaterTiling ) + uv_TexCoord135);
			float2 temp_cast_7 = (( _WaterTiling * 0.667 )).xx;
			float2 uv_TexCoord251 = i.uv_texcoord * temp_cast_7;
			float cos250 = cos( temp_output_226_0 );
			float sin250 = sin( temp_output_226_0 );
			float2 rotator250 = mul( uv_TexCoord251 - float2( 0,0 ) , float2x2( cos250 , -sin250 , sin250 , cos250 )) + float2( 0,0 );
			float2 panner239 = ( 1.0 * _Time.y * ( float2( -0.02,-0.01 ) * _WaterTiling * temp_output_226_0 ) + rotator250);
			float clampResult485 = clamp( ( _WaterTurbulence * (0.0 + (( _WaterHeightLevel + 2.0 ) - 0.0) * (0.25 - 0.0) / (12.0 - 0.0)) * _WaterHeightLevel ) , 0.0 , 1.0 );
			float3 lerpResult300 = lerp( _Vector2 , BlendNormals( UnpackNormal( tex2D( _WaterRippleNormalMap1, panner133 ) ) , UnpackNormal( tex2D( _WaterRippleNormalMap2, panner239 ) ) ) , clampResult485);
			float3 lerpResult231 = lerp( _Vector2 , lerpResult300 , ( clampResult225 * 0.5 ));
			float3 temp_output_333_0 = ( ( float3( i.uv_texcoord ,  0.0 ) * -i.viewDir * temp_output_387_0 ) + ( temp_output_387_0 * lerpResult231 ) );
			float3 lerpResult365 = lerp( float3( uv_TexCoord269 ,  0.0 ) , ( temp_output_333_0 + float3( uv_TexCoord269 ,  0.0 ) ) , WaterMasked368);
			float3 lerpResult366 = lerp( float3( uv_TexCoord270 ,  0.0 ) , ( temp_output_333_0 + float3( uv_TexCoord270 ,  0.0 ) ) , WaterMasked368);
			float3 lerpResult173 = lerp( UnpackNormal( tex2D( _BaseNormalMap, lerpResult365.xy ) ) , UnpackNormal( tex2D( _Masked1NormalMap, lerpResult366.xy ) ) , Mask1_reg138);
			float3 lerpResult367 = lerp( float3( uv_TexCoord271 ,  0.0 ) , ( temp_output_333_0 + float3( uv_TexCoord271 ,  0.0 ) ) , WaterMasked368);
			float3 lerpResult174 = lerp( lerpResult173 , UnpackNormal( tex2D( _Masked2NormalMap, lerpResult367.xy ) ) , Mask2_reg139);
			float3 lerpResult221 = lerp( lerpResult174 , lerpResult231 , clampResult220);
			o.Normal = lerpResult221;
			float4 _AbosulteBaseCol = float4(0.007352948,0.007352948,0.007352948,0);
			float4 tex2DNode1 = tex2D( _BaseAlbedoCutout, lerpResult365.xy );
			float4 lerpResult530 = lerp( _AbosulteBaseCol , ( _BaseColor * tex2DNode1 * _BaseColor ) , _BaseColor.a);
			float4 tex2DNode4 = tex2D( _Masked1AlbedoCutout, lerpResult366.xy );
			float4 temp_output_147_0 = ( _Masked1ColorLayerAmount * tex2DNode4 * _Masked1ColorLayerAmount );
			float4 lerpResult137 = lerp( lerpResult530 , temp_output_147_0 , Mask1_reg138);
			float4 tex2DNode9 = tex2D( _Masked2AlbedoCutout, lerpResult367.xy );
			float4 temp_output_149_0 = ( _Masked2ColorLayerAmount * tex2DNode9 * _Masked2ColorLayerAmount );
			float4 lerpResult141 = lerp( lerpResult137 , temp_output_149_0 , Mask2_reg139);
			float4 lerpResult461 = lerp( lerpResult530 , temp_output_147_0 , 0.5);
			float4 lerpResult463 = lerp( lerpResult461 , temp_output_149_0 , 0.5);
			float temp_output_496_0 = ( WaterMasked368 * _WaterColorMuddyness.a );
			float4 lerpResult515 = lerp( lerpResult141 , ( lerpResult463 * _WaterColorMuddyness ) , temp_output_496_0);
			float4 lerpResult517 = lerp( lerpResult515 , ( _WaterColorMuddyness * temp_output_496_0 ) , ( _WaterColorMuddyness.a * temp_output_496_0 ));
			float4 lerpResult531 = lerp( _AbosulteBaseCol , lerpResult517 , _BaseColor.b);
			o.Albedo = lerpResult531.rgb;
			#ifdef _INVERT_AO_ON
				float staticSwitch524 = ( 1.0 - tex2DNode7.b );
			#else
				float staticSwitch524 = tex2DNode7.b;
			#endif
			#ifdef _TREAT_AO_AS_EMISSIVE_ON
				float staticSwitch520 = staticSwitch524;
			#else
				float staticSwitch520 = (float)0;
			#endif
			float3 temp_cast_23 = (staticSwitch520).xxx;
			o.Emission = temp_cast_23;
			float lerpResult143 = lerp( tex2DNode2.r , tex2DNode6.r , Mask1_reg138);
			float lerpResult152 = lerp( lerpResult143 , tex2DNode7.r , Mask2_reg139);
			float clampResult534 = clamp( _WaterMetallicGloss.x , 0.0 , 1.0 );
			float lerpResult188 = lerp( lerpResult152 , clampResult534 , clampResult220);
			o.Metallic = ( lerpResult188 + _Master_MetalnessAdd );
			float lerpResult155 = lerp( tex2DNode2.g , tex2DNode6.g , Mask1_reg138);
			float lerpResult156 = lerp( lerpResult155 , tex2DNode7.g , Mask2_reg139);
			#ifdef _USESSMOOTHNESS_ON
				float staticSwitch158 = lerpResult156;
			#else
				float staticSwitch158 = ( 1.0 - lerpResult156 );
			#endif
			float clampResult535 = clamp( _WaterMetallicGloss.y , 0.0 , 1.0 );
			float lerpResult189 = lerp( staticSwitch158 , clampResult535 , clampResult220);
			o.Smoothness = ( lerpResult189 + _Master_GlossAdd );
			float lerpResult501 = lerp( tex2DNode2.b , tex2DNode6.b , Mask1_reg138);
			float lerpResult504 = lerp( lerpResult501 , tex2DNode7.b , Mask2_reg139);
			float clampResult509 = clamp( ( lerpResult504 + WaterMasked368 + WaterMasked368 ) , 0.0 , 1.0 );
			float blendOpSrc514 = clampResult509;
			float blendOpDest514 = WaterMasked368;
			float lerpResult532 = lerp( 1.0 , ( saturate( ( 1.0 - ( 1.0 - blendOpSrc514 ) * ( 1.0 - blendOpDest514 ) ) )) , _BaseColor.b);
			o.Occlusion = lerpResult532;
			o.Alpha = 1;
			float lerpResult522 = lerp( tex2DNode1.a , tex2DNode4.a , Mask1_reg138);
			float lerpResult523 = lerp( lerpResult522 , tex2DNode9.a , Mask2_reg139);
			clip( lerpResult523 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15401
7;29;1906;1014;1187.927;-529.821;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;545;-4906.731,-1361.787;Float;False;Property;_RGBMask_Tiling;RGBMask_Tiling;7;0;Create;True;0;0;False;0;0.5;0.5;0.5;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;102;-3985.9,-2150.191;Float;False;3815.964;1266.382;Comment;31;139;307;138;264;306;263;210;112;209;208;110;207;95;39;111;85;100;90;44;131;96;130;129;101;86;77;30;60;91;66;529;NOISE MAKERS;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;544;-4360.307,-1405.967;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-3939.356,-1770.992;Float;False;Property;_NoiseTilingMaster;NoiseTilingMaster;39;0;Create;True;0;0;False;0;1;0.46;0.1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;60;-3911.304,-1525.794;Float;True;Property;_RGBNoisemap;RGB-Noisemap;6;1;[NoScaleOffset];Create;True;0;0;False;0;None;01608cd71c110f04087d173fdd8a27b0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;66;-3588.063,-1967.918;Float;False;Property;_NoiseMod1;NoiseMod1;40;0;Create;True;0;0;False;0;0.1;0.45;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-3567.957,-1524.475;Float;False;Property;_NoiseMod2;NoiseMod2;41;0;Create;True;0;0;False;0;0.1;1.22;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-3223.378,-1982.727;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-3603.427,-1123.208;Float;False;Property;_NoiseMod3;NoiseMod3;42;0;Create;True;0;0;False;0;0.1;0.03;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-3245.288,-1533.96;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;130;-2898.878,-1508.051;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-3242.543,-1118.814;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;129;-2869.809,-1985.122;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;131;-2849.805,-1124.072;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;90;-2547.149,-1497.146;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;44;-2566.54,-1968.78;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;85;-2208.927,-1545.302;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;100;-2560.689,-1102.17;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-2048.122,-1526.87;Float;False;Property;_NoiseLerper;NoiseLerper;43;0;Create;True;0;0;False;0;0.5;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;39;-2188.739,-1964.13;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;527;-5516.758,-84.71746;Float;False;1328.573;1149.076;Comment;16;272;268;270;273;269;271;332;316;333;369;312;311;366;313;365;367;UV Distortion;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;272;-5459.849,563.0848;Float;False;Property;_Masked1Tiling;Masked1-Tiling;19;0;Create;True;0;0;False;0;0.5;8.01;0.5;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;208;-1603.466,-1636.71;Float;False;Constant;_Float2;Float 2;26;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;110;-1578.036,-1809.883;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;207;-1628.128,-1511.624;Float;False;Property;_BaseLayerMix;Base-LayerMix;4;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;268;-5466.758,416.6634;Float;False;Property;_BaseTiling;Base-Tiling;12;0;Create;True;0;0;False;0;0.5;1.64;0.5;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;95;-2226,-1107.143;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;169;-2269.919,-6.36335;Float;False;2057.93;1304.844;Comment;32;347;351;350;349;352;160;162;348;154;157;156;155;153;6;7;152;158;143;159;151;2;297;293;294;356;357;358;359;360;361;363;364;MRH;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;209;-1301.975,-1803.653;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;270;-5077.023,585.8907;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;112;-1655.044,-1414.48;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;269;-5063.284,388.7268;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;273;-5438.529,756.5588;Float;False;Property;_Masked2Tiling;Masked2-Tiling;26;0;Create;True;0;0;False;0;0.5;0.5;0.5;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;146;-4350.562,-530.3028;Float;False;Property;_Masked1ColorLayerAmount;Masked1Color/LayerAmount;18;0;Create;True;0;0;False;0;1,1,1,1;0.7720588,0.7470022,0.5449827,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;271;-5091.768,802.8607;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;349;-2147.784,667.3561;Float;False;Property;_Masked1HeightBoost;Masked1HeightBoost;20;0;Create;True;0;0;False;0;1;0;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;263;-1128.011,-1737.355;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;210;-1277.3,-1507.986;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-2213.7,477.1422;Float;True;Property;_Masked1MetalGlossAOHeightA;Masked1-Metal/Gloss/AO/Height(A);16;1;[NoScaleOffset];Create;True;0;0;False;0;None;d98746ae240007d418d9c2c51a5f84a6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;347;-2113.344,280.3745;Float;False;Property;_BaseHeightBoost;BaseHeightBoost;13;0;Create;True;0;0;False;0;1;25.46;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-2207.877,78.30905;Float;True;Property;_BaseMetalGlossAOHeightA;Base-Metal/Gloss/AO/Height(A);9;1;[NoScaleOffset];Create;True;0;0;False;0;None;83a95f821f1725541b21ceb123d1602d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;148;-4356.307,-341.965;Float;False;Property;_Masked2ColorLayerAmount;Masked2Color/LayerAmount;25;0;Create;True;0;0;False;0;1,1,1,1;0.4926471,0.3839749,0.3839749,0.197;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;350;-2156.388,741.6042;Float;False;Property;_Masked1HeightOffset;Masked1HeightOffset;21;0;Create;True;0;0;False;0;0;-3.81;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-2241.463,831.3999;Float;True;Property;_Masked2MetalGlossAOEmisHeightA;Masked2-Metal/Gloss/AO-Emis/Height(A);23;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;356;-1756.943,244.0296;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;348;-2113.384,354.6799;Float;False;Property;_BaseHeightOffset;BaseHeightOffset;14;0;Create;True;0;0;False;0;0;0;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;264;-1124.69,-1374.631;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;255;-3225.222,2007.315;Float;False;2454.929;898.1309;Comment;22;238;300;231;232;287;12;235;239;133;135;224;250;241;240;251;136;252;229;253;305;485;178;Water Effects;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;352;-2162.73,1056.35;Float;False;Property;_Masked2HeightBoost;Masked2HeightBoost;27;0;Create;True;0;0;False;0;1;0;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;306;-902.6852,-1717.428;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;358;-1803.978,613.8269;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;351;-2165.12,1139.009;Float;False;Property;_Masked2HeightOffset;Masked2HeightOffset;28;0;Create;True;0;0;False;0;0;-1.77;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;360;-1797.491,1009.574;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;138;-521.4584,-1727.122;Float;False;Mask1_reg;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;307;-892.9131,-1448.692;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;526;-7023.07,-179.1391;Float;False;1340.397;1173.674;Comment;14;385;383;386;345;481;480;380;388;309;314;315;475;474;387;Refraction;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;359;-1552.582,620.3145;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;178;-2460.063,2146.045;Float;False;Property;_WaterHeightLevel;WaterHeightLevel;33;0;Create;True;0;0;False;0;0.2;4.22;-2;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;357;-1528.252,339.7227;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;229;-3168.294,2305.919;Float;False;Property;_WaterTiling;WaterTiling;34;0;Create;True;0;0;False;0;2;4.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;160;-1564.161,740.2029;Float;False;138;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;256;-731.6606,2392.272;Float;False;675.3661;369.153;Comment;5;227;226;233;225;234;Fraction;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;253;-3191.958,2474.531;Float;False;Constant;_Float5;Float 5;26;0;Create;True;0;0;False;0;0.667;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;225;-676.5851,2426.296;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;361;-1615.836,1106.89;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;-514.3862,-1456.898;Float;False;Mask2_reg;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;162;-1484.544,1193.969;Float;False;139;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;385;-6973.07,503.0759;Float;False;Constant;_Float0;Float 0;37;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;252;-2834.222,2400.258;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;363;-1273.612,665.729;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;227;-604.5106,2605.629;Float;False;Constant;_Float3;Float 3;27;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;294;-1153.929,1156.135;Float;False;Constant;_Float1;Float 1;31;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;383;-6789.07,360.0759;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;226;-369.0468,2453.259;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;136;-3009.877,2523.805;Float;False;Constant;_Vector0;Vector 0;19;0;Create;True;0;0;False;0;0.01,0.02;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;257;-169.6658,1028.259;Float;False;562.814;470.2424;Comment;4;219;220;215;221;Extraction;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;364;-904.4918,937.6059;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;240;-2975.302,2734.047;Float;False;Constant;_Vector3;Vector 3;19;0;Create;True;0;0;False;0;-0.02,-0.01;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;251;-2640.685,2509.921;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;345;-6958.485,638.6595;Float;False;Property;_RefractionAmount;RefractionAmount;36;0;Create;True;0;0;False;0;0.2;0.18;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;224;-2500.866,2342.461;Float;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;386;-6620.07,325.076;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;12;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;135;-2756.877,2226.968;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;250;-2380.793,2544.574;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0.01;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;219;11.14841,1304.501;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;293;-876.4869,1103.171;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;-2599.29,2717.973;Float;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;481;-6416.094,569.1052;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;133;-2293.4,2287.386;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;239;-2141.821,2554.715;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;287;-1759.5,2746.566;Float;False;Property;_WaterTurbulence;WaterTurbulence;35;0;Create;True;0;0;False;0;0.3;0.18;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;220;184.1096,1257.404;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;297;-624.9297,1106.92;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;12;False;3;FLOAT;0;False;4;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;480;-6260.094,734.1053;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;368;461.2776,1329.2;Float;False;WaterMasked;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;235;-1869.483,2514.068;Float;True;Property;_WaterRippleNormalMap2;WaterRipple-NormalMap2;37;1;[NoScaleOffset];Create;True;0;0;False;0;None;a9c449e102685d34fa04ef3f86190bc7;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;475;-6842.411,861.3292;Float;False;368;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-1864.846,2271.909;Float;True;Property;_WaterRippleNormalMap1;WaterRipple-NormalMap1;38;1;[NoScaleOffset];Create;True;0;0;False;0;None;a9c449e102685d34fa04ef3f86190bc7;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;305;-1416.797,2580.272;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;474;-6140.979,838.5352;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;238;-1535.626,2342.388;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;485;-1186.865,2567.576;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;234;-406.6142,2646.424;Float;False;Constant;_Float4;Float 4;28;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;232;-2012.108,2138.315;Float;False;Constant;_Vector2;Vector 2;28;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;233;-258.2943,2476.281;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;388;-6092.732,573.5583;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;309;-6311.356,-62.58979;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;300;-1054.383,2374.931;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SinOpNode;380;-6071.957,295.9793;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;387;-5851.673,274.0858;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;231;-1037.6,2175.288;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;315;-5993.924,-129.1391;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;314;-5962.502,15.7455;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;316;-5336.914,-34.71747;Float;False;3;3;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;332;-5419.395,212.5778;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;333;-5108.25,220.5946;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;311;-4739.454,211.4104;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;369;-4782.838,949.3585;Float;False;368;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;312;-4741.218,458.2024;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;365;-4376.051,377.6502;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;170;-3930.226,-550.6993;Float;False;1599.344;806.8704;Comment;13;4;1;140;145;9;147;137;149;142;141;461;463;523;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;366;-4372.184,561.7344;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1;-3851.418,-408.6386;Float;True;Property;_BaseAlbedoCutout;Base-Albedo/Cutout;8;1;[NoScaleOffset];Create;True;0;0;False;0;None;d4b4cb767861e7e458bba2f9dbd98af1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;144;-4329.716,-785.8603;Float;False;Property;_BaseColor;BaseColor;11;0;Create;True;0;0;False;0;1,1,1,1;0.8676471,0.8676471,0.8676471,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;313;-4737.692,701.4691;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;4;-3851.23,-178.5448;Float;True;Property;_Masked1AlbedoCutout;Masked1-Albedo/Cutout;15;1;[NoScaleOffset];Create;True;0;0;False;0;None;3d7771406cf19a248a460e2c5f374901;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;529;-3920.718,-1086.508;Float;False;Constant;_AbosulteBaseCol;AbosulteBaseCol;41;0;Create;True;0;0;False;0;0.007352948,0.007352948,0.007352948,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;505;-193.0235,-660.507;Float;False;1723.568;599.66;Comment;8;514;509;507;508;504;502;501;503;AO;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;367;-4372.184,732.0391;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-3413.958,-498.3342;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;503;-143.0235,-511.9025;Float;False;138;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;154;-1231.541,518.3831;Float;False;138;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;462;-3076.716,-324.2551;Float;False;Constant;_Float6;Float 6;37;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;-3257.47,-219.9668;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;530;-3169.267,-679.5408;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;9;-3683.716,26.17101;Float;True;Property;_Masked2AlbedoCutout;Masked2-Albedo/Cutout;22;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;140;-3023.687,-79.28893;Float;False;138;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;155;-1014.15,476.1464;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;502;29.30458,-408.1798;Float;False;139;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;501;158.4546,-610.507;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;157;-1034.998,658.5998;Float;False;139;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;-3233.226,4.949645;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;461;-2781.115,-476.7059;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;186;-2270.833,-353.3768;Float;False;Property;_WaterColorMuddyness;WaterColor/Muddyness;31;0;Create;True;0;0;False;0;0.1706855,0.236529,0.3014706,0;0.2068015,0.2914807,0.375,0.516;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;504;352.0059,-529.912;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;137;-2750.731,-188.0627;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;508;-208.8934,-367.2173;Float;True;368;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;156;-829.8663,591.22;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;466;-2268.653,-608.1323;Float;False;368;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;254;-2280.24,1325.313;Float;False;1057.566;705.7681;Comment;7;3;5;8;172;171;173;174;NormalMaps;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;463;-2502.459,-474.1794;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;-3043.827,77.84072;Float;False;139;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;151;-1535.49,176.9977;Float;False;138;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;496;-1878.193,-192.1403;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;516;-1878.335,-465.6185;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;143;-1234.012,78.39316;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;171;-1869.915,1604.364;Float;False;138;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;507;521.9285,-460.1245;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;141;-2509.952,-101.8724;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;-1240.162,224.7205;Float;False;139;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;159;-659.186,557.3129;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;187;-190.7813,386.6672;Float;False;Property;_WaterMetallicGloss;Water- Metallic-Gloss;32;0;Create;True;0;0;False;0;0.2,0.8;0.2,0.8;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;5;-2223.271,1586.337;Float;True;Property;_Masked1NormalMap;Masked1-NormalMap;17;2;[NoScaleOffset];[Normal];Create;True;0;0;False;0;None;477f9af4c0593364bbf065b0a20d9ca9;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-2230.24,1375.313;Float;True;Property;_BaseNormalMap;Base-NormalMap;10;1;[NoScaleOffset];Create;True;0;0;False;0;None;d5e9854c1cbdd654786a5d3df60cc5d4;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;509;728.997,-415.0317;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;534;142.0761,373.9532;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;172;-1822.832,1858.331;Float;False;139;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;518;-1481.552,-277.4038;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;8;-2228.193,1801.081;Float;True;Property;_Masked2NormalMap;Masked2-NormalMap;24;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;535;151.0761,496.9532;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;158;-466.7303,539.0941;Float;False;Property;_UsesSmoothness;UsesSmoothness;5;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;152;-1007.031,158.9882;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;173;-1661.81,1467.877;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;525;671.7,616.9934;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;519;-1321.985,-234.0792;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;515;-1355.047,-494.1935;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;538;3001.665,699.7781;Float;False;Property;_TessellationMultiplier;TessellationMultiplier;1;0;Create;True;0;0;False;0;0;50;0.1;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;174;-1406.674,1636.59;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;521;993.0614,188.2533;Float;False;Constant;_Int0;Int 0;38;0;Create;True;0;0;False;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;539;3709.166,407.3123;Float;False;Property;_Master_MetalnessAdd;Master_MetalnessAdd;2;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;215;-132.603,1117.156;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;522;-2786.572,150.9787;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;164;-92.47798,688.3389;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;524;834.8573,373.3931;Float;False;Property;_Invert_AO;Invert_AO;30;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;188;364.6981,309.672;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;542;3702.367,544.061;Float;False;Property;_Master_GlossAdd;Master_GlossAdd;3;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;189;1046.219,500.4301;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;517;989.2388,-12.57509;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;533;1551.811,69.37981;Float;False;Constant;_Float7;Float 7;41;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;514;1261.012,-284.1365;Float;False;Screen;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;543;4123.6,497.0192;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceBasedTessNode;537;3382.724,700.6849;Float;False;3;0;FLOAT;0;False;1;FLOAT;10;False;2;FLOAT;50;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;221;138.3046,1078.259;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;520;1297.48,229.0235;Float;False;Property;_Treat_AO_as_Emissive;Treat_AO_as_Emissive;29;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;166;368.5683,699.3572;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;523;-2541.623,124.394;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;532;1951.082,224.0507;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;541;4136.268,375.2141;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;531;2298.86,-86.3949;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4461.729,165.3181;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;MEGA_WaterBasedShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;45.51;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;544;0;545;0
WireConnection;60;1;544;0
WireConnection;77;0;60;1
WireConnection;77;1;66;0
WireConnection;77;2;30;0
WireConnection;86;0;60;2
WireConnection;86;1;91;0
WireConnection;86;2;30;0
WireConnection;130;0;86;0
WireConnection;130;1;86;0
WireConnection;96;0;60;3
WireConnection;96;1;101;0
WireConnection;96;2;30;0
WireConnection;129;0;77;0
WireConnection;129;1;77;0
WireConnection;131;0;96;0
WireConnection;131;1;96;0
WireConnection;90;0;130;0
WireConnection;44;0;129;0
WireConnection;85;0;90;0
WireConnection;100;0;131;0
WireConnection;39;0;44;0
WireConnection;110;0;39;0
WireConnection;110;1;85;0
WireConnection;110;2;111;0
WireConnection;95;0;100;0
WireConnection;209;0;208;0
WireConnection;209;1;110;0
WireConnection;209;2;207;0
WireConnection;270;0;272;0
WireConnection;112;0;85;0
WireConnection;112;1;95;0
WireConnection;112;2;111;0
WireConnection;269;0;268;0
WireConnection;271;0;273;0
WireConnection;263;0;209;0
WireConnection;263;1;146;4
WireConnection;210;0;208;0
WireConnection;210;1;112;0
WireConnection;210;2;207;0
WireConnection;6;1;270;0
WireConnection;2;1;269;0
WireConnection;7;1;271;0
WireConnection;356;0;2;4
WireConnection;356;1;347;0
WireConnection;264;0;210;0
WireConnection;264;1;148;4
WireConnection;306;0;263;0
WireConnection;358;0;6;4
WireConnection;358;1;349;0
WireConnection;360;0;7;4
WireConnection;360;1;352;0
WireConnection;138;0;306;0
WireConnection;307;0;264;0
WireConnection;359;0;358;0
WireConnection;359;1;350;0
WireConnection;357;0;356;0
WireConnection;357;1;348;0
WireConnection;225;0;178;0
WireConnection;361;0;360;0
WireConnection;361;1;351;0
WireConnection;139;0;307;0
WireConnection;252;0;229;0
WireConnection;252;1;253;0
WireConnection;363;0;357;0
WireConnection;363;1;359;0
WireConnection;363;2;160;0
WireConnection;383;0;178;0
WireConnection;383;1;385;0
WireConnection;226;0;225;0
WireConnection;226;1;227;0
WireConnection;364;0;363;0
WireConnection;364;1;361;0
WireConnection;364;2;162;0
WireConnection;251;0;252;0
WireConnection;224;0;136;0
WireConnection;224;1;226;0
WireConnection;224;2;229;0
WireConnection;386;0;383;0
WireConnection;135;0;229;0
WireConnection;250;0;251;0
WireConnection;250;2;226;0
WireConnection;219;0;178;0
WireConnection;219;1;364;0
WireConnection;293;0;178;0
WireConnection;293;1;294;0
WireConnection;241;0;240;0
WireConnection;241;1;229;0
WireConnection;241;2;226;0
WireConnection;481;0;345;0
WireConnection;481;1;386;0
WireConnection;133;0;135;0
WireConnection;133;2;224;0
WireConnection;239;0;250;0
WireConnection;239;2;241;0
WireConnection;220;0;219;0
WireConnection;297;0;293;0
WireConnection;480;0;481;0
WireConnection;480;1;345;0
WireConnection;368;0;220;0
WireConnection;235;1;239;0
WireConnection;12;1;133;0
WireConnection;305;0;287;0
WireConnection;305;1;297;0
WireConnection;305;2;178;0
WireConnection;474;0;480;0
WireConnection;474;1;475;0
WireConnection;474;2;475;0
WireConnection;238;0;12;0
WireConnection;238;1;235;0
WireConnection;485;0;305;0
WireConnection;233;0;225;0
WireConnection;233;1;234;0
WireConnection;388;0;386;0
WireConnection;388;1;474;0
WireConnection;300;0;232;0
WireConnection;300;1;238;0
WireConnection;300;2;485;0
WireConnection;380;0;386;0
WireConnection;387;0;380;0
WireConnection;387;1;388;0
WireConnection;231;0;232;0
WireConnection;231;1;300;0
WireConnection;231;2;233;0
WireConnection;314;0;309;0
WireConnection;316;0;315;0
WireConnection;316;1;314;0
WireConnection;316;2;387;0
WireConnection;332;0;387;0
WireConnection;332;1;231;0
WireConnection;333;0;316;0
WireConnection;333;1;332;0
WireConnection;311;0;333;0
WireConnection;311;1;269;0
WireConnection;312;0;333;0
WireConnection;312;1;270;0
WireConnection;365;0;269;0
WireConnection;365;1;311;0
WireConnection;365;2;369;0
WireConnection;366;0;270;0
WireConnection;366;1;312;0
WireConnection;366;2;369;0
WireConnection;1;1;365;0
WireConnection;313;0;333;0
WireConnection;313;1;271;0
WireConnection;4;1;366;0
WireConnection;367;0;271;0
WireConnection;367;1;313;0
WireConnection;367;2;369;0
WireConnection;145;0;144;0
WireConnection;145;1;1;0
WireConnection;145;2;144;0
WireConnection;147;0;146;0
WireConnection;147;1;4;0
WireConnection;147;2;146;0
WireConnection;530;0;529;0
WireConnection;530;1;145;0
WireConnection;530;2;144;4
WireConnection;9;1;367;0
WireConnection;155;0;2;2
WireConnection;155;1;6;2
WireConnection;155;2;154;0
WireConnection;501;0;2;3
WireConnection;501;1;6;3
WireConnection;501;2;503;0
WireConnection;149;0;148;0
WireConnection;149;1;9;0
WireConnection;149;2;148;0
WireConnection;461;0;530;0
WireConnection;461;1;147;0
WireConnection;461;2;462;0
WireConnection;504;0;501;0
WireConnection;504;1;7;3
WireConnection;504;2;502;0
WireConnection;137;0;530;0
WireConnection;137;1;147;0
WireConnection;137;2;140;0
WireConnection;156;0;155;0
WireConnection;156;1;7;2
WireConnection;156;2;157;0
WireConnection;463;0;461;0
WireConnection;463;1;149;0
WireConnection;463;2;462;0
WireConnection;496;0;466;0
WireConnection;496;1;186;4
WireConnection;516;0;463;0
WireConnection;516;1;186;0
WireConnection;143;0;2;1
WireConnection;143;1;6;1
WireConnection;143;2;151;0
WireConnection;507;0;504;0
WireConnection;507;1;508;0
WireConnection;507;2;508;0
WireConnection;141;0;137;0
WireConnection;141;1;149;0
WireConnection;141;2;142;0
WireConnection;159;0;156;0
WireConnection;5;1;366;0
WireConnection;3;1;365;0
WireConnection;509;0;507;0
WireConnection;534;0;187;1
WireConnection;518;0;186;0
WireConnection;518;1;496;0
WireConnection;8;1;367;0
WireConnection;535;0;187;2
WireConnection;158;1;159;0
WireConnection;158;0;156;0
WireConnection;152;0;143;0
WireConnection;152;1;7;1
WireConnection;152;2;153;0
WireConnection;173;0;3;0
WireConnection;173;1;5;0
WireConnection;173;2;171;0
WireConnection;525;0;7;3
WireConnection;519;0;186;4
WireConnection;519;1;496;0
WireConnection;515;0;141;0
WireConnection;515;1;516;0
WireConnection;515;2;496;0
WireConnection;174;0;173;0
WireConnection;174;1;8;0
WireConnection;174;2;172;0
WireConnection;215;0;364;0
WireConnection;215;1;178;0
WireConnection;522;0;1;4
WireConnection;522;1;4;4
WireConnection;522;2;140;0
WireConnection;524;1;7;3
WireConnection;524;0;525;0
WireConnection;188;0;152;0
WireConnection;188;1;534;0
WireConnection;188;2;220;0
WireConnection;189;0;158;0
WireConnection;189;1;535;0
WireConnection;189;2;220;0
WireConnection;517;0;515;0
WireConnection;517;1;518;0
WireConnection;517;2;519;0
WireConnection;514;0;509;0
WireConnection;514;1;508;0
WireConnection;543;0;189;0
WireConnection;543;1;542;0
WireConnection;537;0;538;0
WireConnection;221;0;174;0
WireConnection;221;1;231;0
WireConnection;221;2;220;0
WireConnection;520;1;521;0
WireConnection;520;0;524;0
WireConnection;166;0;164;0
WireConnection;166;1;215;0
WireConnection;523;0;522;0
WireConnection;523;1;9;4
WireConnection;523;2;142;0
WireConnection;532;0;533;0
WireConnection;532;1;514;0
WireConnection;532;2;144;3
WireConnection;541;0;188;0
WireConnection;541;1;539;0
WireConnection;531;0;529;0
WireConnection;531;1;517;0
WireConnection;531;2;144;3
WireConnection;0;0;531;0
WireConnection;0;1;221;0
WireConnection;0;2;520;0
WireConnection;0;3;541;0
WireConnection;0;4;543;0
WireConnection;0;5;532;0
WireConnection;0;10;523;0
WireConnection;0;11;166;0
WireConnection;0;14;537;0
ASEEND*/
//CHKSM=2939D745DFD0CE59C2E4E3A4F8E941AE7E4B4B85
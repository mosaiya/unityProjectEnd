// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MEGA_Shader"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_LayerTilingMaster("LayerTilingMaster", Range( 1 , 10)) = 1
		_BaseLayerMix("Base-Layer-Mix", Range( 0 , 1)) = 1
		_GlobalSmoothnessMultiplier("GlobalSmoothnessMultiplier", Range( 0 , 1.5)) = 1
		_GlobalMetallicMultiplier("GlobalMetallicMultiplier", Range( 0 , 1.5)) = 1
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 1.85
		_TessMin( "Tess Min Distance", Float ) = 1.48
		_TessMax( "Tess Max Distance", Float ) = 48.38
		[Toggle(_ROUGHNESSMODE_ON)] _RoughnessMode("Roughness Mode", Float) = 1
		[Toggle(_INVERTAO_ON)] _InvertAO("Invert AO", Float) = 0
		[NoScaleOffset]_RGBMask("RGB-Mask", 2D) = "white" {}
		[NoScaleOffset]_BaseAlbedo("Base-Albedo", 2D) = "white" {}
		[NoScaleOffset]_Base_NormalMap("Base_NormalMap", 2D) = "bump" {}
		[NoScaleOffset]_BaseMetalRRoughGAORHeightA("Base Metal(R)-Rough(G)AO(R)-Height(A)", 2D) = "white" {}
		_BaseColorInclusion("Base-Color/Inclusion", Color) = (1,1,1,1)
		_BaseHeightAmount("Base-Height-Amount", Range( 0 , 50)) = 0
		_BaseHeightOffset("Base-Height-Offset", Range( -4 , 4)) = 0
		[NoScaleOffset]_RAlbedoCutout("R-Albedo/Cutout", 2D) = "white" {}
		[NoScaleOffset]_RNormal("R-Normal", 2D) = "bump" {}
		[NoScaleOffset]_RMetalRoughAOHeightA("R-MetalRoughAO Height(A)", 2D) = "black" {}
		_RColorMix("R-Color/Mix", Color) = (0.9558824,0.9558824,0.9558824,0)
		_RHeightAmount("R-Height-Amount", Range( 0 , 10)) = 0
		_RHeightOffset("R-Height-Offset", Range( -4 , 0.5)) = 0
		_RBrightness("R-Brightness", Range( -4 , 8)) = 1
		_RContrast("R-Contrast", Range( 0 , 8)) = 1
		_RAmount("R-Amount", Range( 0 , 2)) = 1
		_RTexTiling("R-TexTiling", Range( 0.1 , 40)) = 1
		_RMaskTiling("R-MaskTiling", Range( 0 , 8)) = 1
		[NoScaleOffset]_GAlbedoCutout("G-Albedo/Cutout", 2D) = "white" {}
		[NoScaleOffset]_GNormal("G-Normal", 2D) = "bump" {}
		[NoScaleOffset]_GMetalRoughAOHeightA("G-MetalRoughAO Height(A)", 2D) = "black" {}
		_GColorMix("G-Color/Mix", Color) = (0.9558824,0.9558824,0.9558824,0.978)
		_GHeightAmount("G-Height-Amount", Range( 0 , 10)) = 0
		_GHeightOffset("G-Height-Offset", Range( -4 , 0.5)) = 0
		_GBrightness("G-Brightness", Range( -4 , 8)) = 1
		_GContrast("G-Contrast", Range( 0 , 8)) = 1
		_GAmount("G-Amount", Range( 0 , 2)) = 1
		_GTexTiling("G-TexTiling", Range( 0.1 , 40)) = 1
		_GMaskTiling("G-MaskTiling", Range( 0 , 8)) = 1
		[NoScaleOffset]_BAlbedoCutout("B-Albedo/Cutout", 2D) = "white" {}
		[NoScaleOffset]_BNormal("B-Normal", 2D) = "bump" {}
		[NoScaleOffset]_BMetalRoughAOHeightA("B-MetalRoughAO  Height(A)", 2D) = "black" {}
		_BColorMix("B-Color/Mix", Color) = (1,1,1,1)
		_BHeightAmount("B-Height-Amount", Range( 0 , 10)) = 0
		_BHeightOffset("B-Height-Offset", Range( -4 , 0.5)) = 0
		_BBrightness("B-Brightness", Range( -4 , 8)) = 1
		_BContrast("B-Contrast", Range( 0 , 8)) = 1
		_BAmount("B-Amount", Range( 0 , 2)) = 1
		_BTexTiling("B-TexTiling", Range( 0.1 , 40)) = 1
		_BMaskTiling("B-MaskTiling", Range( 0 , 8)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma shader_feature _ROUGHNESSMODE_ON
		#pragma shader_feature _INVERTAO_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _RGBMask;
		uniform float _RMaskTiling;
		uniform float _LayerTilingMaster;
		uniform float _RContrast;
		uniform float _RBrightness;
		uniform float _RAmount;
		uniform float _GAmount;
		uniform float _GMaskTiling;
		uniform float _GContrast;
		uniform float _GBrightness;
		uniform float _BMaskTiling;
		uniform float _BContrast;
		uniform float _BBrightness;
		uniform float _BAmount;
		uniform sampler2D _BaseMetalRRoughGAORHeightA;
		uniform float _BaseHeightAmount;
		uniform float _BaseHeightOffset;
		uniform sampler2D _RMetalRoughAOHeightA;
		uniform float _RTexTiling;
		uniform float _RHeightOffset;
		uniform float _RHeightAmount;
		uniform sampler2D _GMetalRoughAOHeightA;
		uniform float _GTexTiling;
		uniform float _GHeightOffset;
		uniform float _GHeightAmount;
		uniform float _BHeightAmount;
		uniform sampler2D _BMetalRoughAOHeightA;
		uniform float _BTexTiling;
		uniform float _BHeightOffset;
		uniform sampler2D _Base_NormalMap;
		uniform sampler2D _RNormal;
		uniform sampler2D _GNormal;
		uniform sampler2D _BNormal;
		uniform float _BaseLayerMix;
		uniform float4 _BaseColorInclusion;
		uniform sampler2D _BaseAlbedo;
		uniform float4 _RColorMix;
		uniform sampler2D _RAlbedoCutout;
		uniform float4 _GColorMix;
		uniform sampler2D _GAlbedoCutout;
		uniform float4 _BColorMix;
		uniform sampler2D _BAlbedoCutout;
		uniform float _GlobalMetallicMultiplier;
		uniform float _GlobalSmoothnessMultiplier;
		uniform float _Cutoff = 0.5;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertexNormal = v.normal.xyz;
			float2 temp_cast_0 = (_RMaskTiling).xx;
			float2 uv_TexCoord4 = v.texcoord.xy * temp_cast_0;
			float2 temp_cast_1 = (_LayerTilingMaster).xx;
			float2 uv_TexCoord108 = v.texcoord.xy * temp_cast_1;
			float temp_output_6_0 = pow( tex2Dlod( _RGBMask, float4( ( uv_TexCoord4 + uv_TexCoord108 ), 0, 0.0) ).r , _RContrast );
			float clampResult164 = clamp( ( ( temp_output_6_0 + ( temp_output_6_0 * _RContrast * _RBrightness ) ) * _RAmount ) , 0.0 , 1.0 );
			float2 temp_cast_2 = (_GMaskTiling).xx;
			float2 uv_TexCoord18 = v.texcoord.xy * temp_cast_2;
			float temp_output_22_0 = pow( tex2Dlod( _RGBMask, float4( ( uv_TexCoord108 + uv_TexCoord18 ), 0, 0.0) ).g , _GContrast );
			float clampResult162 = clamp( ( _GAmount * ( temp_output_22_0 + ( temp_output_22_0 * _GContrast * _GBrightness ) ) ) , 0.0 , 1.0 );
			float2 temp_cast_3 = (_BMaskTiling).xx;
			float2 uv_TexCoord26 = v.texcoord.xy * temp_cast_3;
			float temp_output_30_0 = pow( tex2Dlod( _RGBMask, float4( ( uv_TexCoord108 + uv_TexCoord26 ), 0, 0.0) ).b , _BContrast );
			float clampResult163 = clamp( ( ( temp_output_30_0 + ( temp_output_30_0 * _BContrast * _BBrightness ) ) * _BAmount ) , 0.0 , 1.0 );
			float3 appendResult12 = (float3(clampResult164 , clampResult162 , clampResult163));
			float4 tex2DNode95 = tex2Dlod( _BaseMetalRRoughGAORHeightA, float4( uv_TexCoord108, 0, 0.0) );
			float temp_output_111_0 = ( ( tex2DNode95.a * _BaseHeightAmount ) + _BaseHeightOffset );
			float2 temp_cast_4 = (_RTexTiling).xx;
			float2 uv_TexCoord178 = v.texcoord.xy * temp_cast_4;
			float2 temp_output_179_0 = ( uv_TexCoord178 + uv_TexCoord108 );
			float4 tex2DNode14 = tex2Dlod( _RMetalRoughAOHeightA, float4( temp_output_179_0, 0, 0.0) );
			float2 temp_cast_5 = (_GTexTiling).xx;
			float2 uv_TexCoord180 = v.texcoord.xy * temp_cast_5;
			float2 temp_output_182_0 = ( uv_TexCoord108 + uv_TexCoord180 );
			float4 tex2DNode60 = tex2Dlod( _GMetalRoughAOHeightA, float4( temp_output_182_0, 0, 0.0) );
			float temp_output_128_0 = ( ( tex2DNode60.a + _GHeightOffset ) * _GHeightAmount );
			float clampResult259 = clamp( ( ( ( tex2DNode14.a + _RHeightOffset ) * _RHeightAmount ) - ( temp_output_128_0 * 3.0 ) ) , 0.0 , 1.0 );
			float clampResult263 = clamp( ( temp_output_128_0 - ( 0.0 * 3.0 ) ) , 0.0 , 1.0 );
			float2 temp_cast_6 = (_BTexTiling).xx;
			float2 uv_TexCoord184 = v.texcoord.xy * temp_cast_6;
			float2 temp_output_185_0 = ( uv_TexCoord184 + uv_TexCoord108 );
			float4 tex2DNode61 = tex2Dlod( _BMetalRoughAOHeightA, float4( temp_output_185_0, 0, 0.0) );
			float temp_output_124_0 = ( _BHeightAmount * ( tex2DNode61.a + _BHeightOffset ) );
			float clampResult267 = clamp( ( ( 3.0 * 0.0 ) - temp_output_124_0 ) , 0.0 , 1.0 );
			float3 layeredBlendVar270 = appendResult12;
			float layeredBlend270 = ( lerp( lerp( lerp( temp_output_111_0 , ( clampResult259 + temp_output_128_0 ) , layeredBlendVar270.x ) , ( clampResult263 + temp_output_128_0 ) , layeredBlendVar270.y ) , ( clampResult267 + temp_output_124_0 ) , layeredBlendVar270.z ) );
			v.vertex.xyz += ( ase_vertexNormal * layeredBlend270 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_LayerTilingMaster).xx;
			float2 uv_TexCoord108 = i.uv_texcoord * temp_cast_0;
			float3 tex2DNode94 = UnpackNormal( tex2D( _Base_NormalMap, uv_TexCoord108 ) );
			float2 temp_cast_1 = (_RMaskTiling).xx;
			float2 uv_TexCoord4 = i.uv_texcoord * temp_cast_1;
			float temp_output_6_0 = pow( tex2D( _RGBMask, ( uv_TexCoord4 + uv_TexCoord108 ) ).r , _RContrast );
			float clampResult164 = clamp( ( ( temp_output_6_0 + ( temp_output_6_0 * _RContrast * _RBrightness ) ) * _RAmount ) , 0.0 , 1.0 );
			float2 temp_cast_2 = (_GMaskTiling).xx;
			float2 uv_TexCoord18 = i.uv_texcoord * temp_cast_2;
			float temp_output_22_0 = pow( tex2D( _RGBMask, ( uv_TexCoord108 + uv_TexCoord18 ) ).g , _GContrast );
			float clampResult162 = clamp( ( _GAmount * ( temp_output_22_0 + ( temp_output_22_0 * _GContrast * _GBrightness ) ) ) , 0.0 , 1.0 );
			float2 temp_cast_3 = (_BMaskTiling).xx;
			float2 uv_TexCoord26 = i.uv_texcoord * temp_cast_3;
			float temp_output_30_0 = pow( tex2D( _RGBMask, ( uv_TexCoord108 + uv_TexCoord26 ) ).b , _BContrast );
			float clampResult163 = clamp( ( ( temp_output_30_0 + ( temp_output_30_0 * _BContrast * _BBrightness ) ) * _BAmount ) , 0.0 , 1.0 );
			float3 appendResult12 = (float3(clampResult164 , clampResult162 , clampResult163));
			float2 temp_cast_4 = (_RTexTiling).xx;
			float2 uv_TexCoord178 = i.uv_texcoord * temp_cast_4;
			float2 temp_output_179_0 = ( uv_TexCoord178 + uv_TexCoord108 );
			float2 temp_cast_5 = (_GTexTiling).xx;
			float2 uv_TexCoord180 = i.uv_texcoord * temp_cast_5;
			float2 temp_output_182_0 = ( uv_TexCoord108 + uv_TexCoord180 );
			float2 temp_cast_6 = (_BTexTiling).xx;
			float2 uv_TexCoord184 = i.uv_texcoord * temp_cast_6;
			float2 temp_output_185_0 = ( uv_TexCoord184 + uv_TexCoord108 );
			float3 layeredBlendVar55 = appendResult12;
			float3 layeredBlend55 = ( lerp( lerp( lerp( tex2DNode94 , UnpackNormal( tex2D( _RNormal, temp_output_179_0 ) ) , layeredBlendVar55.x ) , UnpackNormal( tex2D( _GNormal, temp_output_182_0 ) ) , layeredBlendVar55.y ) , UnpackNormal( tex2D( _BNormal, temp_output_185_0 ) ) , layeredBlendVar55.z ) );
			float3 lerpResult150 = lerp( tex2DNode94 , layeredBlend55 , _BaseLayerMix);
			o.Normal = lerpResult150;
			float4 tex2DNode93 = tex2D( _BaseAlbedo, uv_TexCoord108 );
			float4 temp_output_135_0 = ( _BaseColorInclusion * tex2DNode93 );
			float4 tex2DNode13 = tex2D( _RAlbedoCutout, temp_output_179_0 );
			float4 temp_output_47_0 = ( _RColorMix * tex2DNode13 );
			float4 tex2DNode48 = tex2D( _GAlbedoCutout, temp_output_182_0 );
			float4 temp_output_49_0 = ( _GColorMix * tex2DNode48 );
			float4 tex2DNode50 = tex2D( _BAlbedoCutout, temp_output_185_0 );
			float4 temp_output_51_0 = ( _BColorMix * tex2DNode50 );
			float3 layeredBlendVar142 = float3(0.33,0.33,0.33);
			float4 layeredBlend142 = ( lerp( lerp( lerp( temp_output_135_0 , temp_output_47_0 , layeredBlendVar142.x ) , temp_output_49_0 , layeredBlendVar142.y ) , temp_output_51_0 , layeredBlendVar142.z ) );
			float4 lerpResult146 = lerp( temp_output_47_0 , layeredBlend142 , ( 1.0 - _RColorMix.a ));
			float4 lerpResult145 = lerp( temp_output_49_0 , layeredBlend142 , ( 1.0 - _GColorMix.a ));
			float4 lerpResult136 = lerp( temp_output_51_0 , layeredBlend142 , ( 1.0 - _BColorMix.a ));
			float3 layeredBlendVar11 = appendResult12;
			float4 layeredBlend11 = ( lerp( lerp( lerp( temp_output_135_0 , lerpResult146 , layeredBlendVar11.x ) , lerpResult145 , layeredBlendVar11.y ) , lerpResult136 , layeredBlendVar11.z ) );
			float4 lerpResult88 = lerp( temp_output_135_0 , layeredBlend11 , _BaseLayerMix);
			o.Albedo = lerpResult88.rgb;
			float4 tex2DNode95 = tex2D( _BaseMetalRRoughGAORHeightA, uv_TexCoord108 );
			float4 tex2DNode14 = tex2D( _RMetalRoughAOHeightA, temp_output_179_0 );
			float4 tex2DNode60 = tex2D( _GMetalRoughAOHeightA, temp_output_182_0 );
			float4 tex2DNode61 = tex2D( _BMetalRoughAOHeightA, temp_output_185_0 );
			float3 layeredBlendVar54 = appendResult12;
			float4 layeredBlend54 = ( lerp( lerp( lerp( tex2DNode95 , tex2DNode14 , layeredBlendVar54.x ) , tex2DNode60 , layeredBlendVar54.y ) , tex2DNode61 , layeredBlendVar54.z ) );
			o.Metallic = ( (layeredBlend54).r * _GlobalMetallicMultiplier );
			float temp_output_66_0 = (layeredBlend54).g;
			#ifdef _ROUGHNESSMODE_ON
				float staticSwitch63 = ( 1.0 - temp_output_66_0 );
			#else
				float staticSwitch63 = temp_output_66_0;
			#endif
			o.Smoothness = ( staticSwitch63 * _GlobalSmoothnessMultiplier );
			float temp_output_68_0 = (layeredBlend54).b;
			#ifdef _INVERTAO_ON
				float staticSwitch69 = ( 1.0 - temp_output_68_0 );
			#else
				float staticSwitch69 = temp_output_68_0;
			#endif
			o.Occlusion = staticSwitch69;
			o.Alpha = 1;
			float3 layeredBlendVar148 = appendResult12;
			float layeredBlend148 = ( lerp( lerp( lerp( tex2DNode93.a , tex2DNode13.a , layeredBlendVar148.x ) , tex2DNode48.a , layeredBlendVar148.y ) , tex2DNode50.a , layeredBlendVar148.z ) );
			clip( layeredBlend148 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
2115;113;1906;1014;-2742.525;-1171.464;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;147;-2538.787,-83.74168;Float;False;1483.313;1778.079;Base Mixing;23;17;25;5;18;4;2;26;27;19;7;3;24;32;10;20;28;112;115;116;108;226;228;227;Initial Nodes;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-3064.515,742.8374;Float;False;Property;_LayerTilingMaster;LayerTilingMaster;1;0;Create;True;0;0;False;0;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-2275.583,176.813;Float;False;Property;_RMaskTiling;R-MaskTiling;29;0;Create;True;0;0;False;0;1;1.82;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-2271.439,657.8921;Float;False;Property;_GMaskTiling;G-MaskTiling;40;0;Create;True;0;0;False;0;1;1.21;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2292.242,1187.538;Float;False;Property;_BMaskTiling;B-MaskTiling;51;0;Create;True;0;0;False;0;1;0;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1856.005,165.3044;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-1900.333,660.8579;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-1884.263,1168.583;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;108;-2534.747,763.5106;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;227;-1600.159,245.6625;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;2;-2488.787,-33.74168;Float;True;Property;_RGBMask;RGB-Mask;12;1;[NoScaleOffset];Create;True;0;0;False;0;None;23417e5079378c348a9062abcb2ca5e6;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;226;-1629.786,520.382;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;228;-1604.144,1091.966;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;181;-608.1728,948.0228;Float;False;Property;_GTexTiling;G-TexTiling;39;0;Create;True;0;0;False;0;1;16.3;0.1;40;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1406.128,171.274;Float;False;Property;_RContrast;R-Contrast;26;0;Create;True;0;0;False;0;1;2.87;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1378.272,1354.475;Float;False;Property;_BContrast;B-Contrast;48;0;Create;True;0;0;False;0;1;0;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1405.243,805.3924;Float;False;Property;_GContrast;G-Contrast;37;0;Create;True;0;0;False;0;1;4.05;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;32;-1394.019,1135.194;Float;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;24;-1420.515,593.2871;Float;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-1432.528,-22.71289;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;177;-587.8315,534.5518;Float;False;Property;_RTexTiling;R-TexTiling;28;0;Create;True;0;0;False;0;1;6.11;0.1;40;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;180;-244.4404,899.1459;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;183;-551.6187,1347.99;Float;False;Property;_BTexTiling;B-TexTiling;50;0;Create;True;0;0;False;0;1;0.39;0.1;40;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;22;-1034.678,342.5352;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;6;-946.4746,-74.71563;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1365.239,1469.984;Float;False;Property;_BBrightness;B-Brightness;47;0;Create;True;0;0;False;0;1;-3.89;-4;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;30;-949.5663,1127.202;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1408.581,260.5514;Float;False;Property;_RBrightness;R-Brightness;25;0;Create;True;0;0;False;0;1;4.88;-4;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1407.95,894.8041;Float;False;Property;_GBrightness;G-Brightness;36;0;Create;True;0;0;False;0;1;3.43;-4;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;182;50.01173,925.3269;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;184;-209.6187,1310.99;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;178;-238.2374,535.1247;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-727.6879,1198.844;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-718.4859,17.81093;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-830.5831,387.1341;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;179;48.04682,570.7996;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;127;2180.152,898.0966;Float;False;Property;_GHeightOffset;G-Height-Offset;35;0;Create;True;0;0;False;0;0;-0.342;-4;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;60;2217.588,602.5647;Float;True;Property;_GMetalRoughAOHeightA;G-MetalRoughAO Height(A);32;1;[NoScaleOffset];Create;True;0;0;False;0;None;37e6f91f3efb0954cbdce254638862ea;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;185;86.38135,1393.99;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-623.7146,307.9098;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-1411.928,983.6036;Float;False;Property;_GAmount;G-Amount;38;0;Create;True;0;0;False;0;1;0.33;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-1357.474,1579.339;Float;False;Property;_BAmount;B-Amount;49;0;Create;True;0;0;False;0;1;0.18;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-515.8099,-74.62714;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-1405.645,347.6475;Float;False;Property;_RAmount;R-Amount;27;0;Create;True;0;0;False;0;1;1.22;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-518.0823,1114.052;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;129;2610.673,863.4404;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;61;2151.021,1027.712;Float;True;Property;_BMetalRoughAOHeightA;B-MetalRoughAO  Height(A);43;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;131;2143.322,426.7791;Float;False;Property;_RHeightOffset;R-Height-Offset;24;0;Create;True;0;0;False;0;0;-0.07;-4;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;2193.195,1388.439;Float;False;Property;_BHeightOffset;B-Height-Offset;46;0;Create;True;0;0;False;0;0;-0.5;-4;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;14;2115.814,84.82681;Float;True;Property;_RMetalRoughAOHeightA;R-MetalRoughAO Height(A);21;1;[NoScaleOffset];Create;True;0;0;False;0;None;37e6f91f3efb0954cbdce254638862ea;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;126;2199.283,808.772;Float;False;Property;_GHeightAmount;G-Height-Amount;34;0;Create;True;0;0;False;0;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-438.8356,350.1382;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-275.5659,-85.97983;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-339.7128,1188.214;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;120;2598.584,1308.233;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;258;3536.173,1089.104;Float;False;Constant;_Float0;Float 0;49;0;Create;True;0;0;False;0;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;121;2190.755,1304.307;Float;False;Property;_BHeightAmount;B-Height-Amount;45;0;Create;True;0;0;False;0;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;2824.319,944.6094;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;133;2559.379,413.6408;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;2174.452,338.0842;Float;False;Property;_RHeightAmount;R-Height-Amount;23;0;Create;True;0;0;False;0;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;164;526.818,-355.8373;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;162;497.0967,-183.6584;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;163;632.2218,-59.36951;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;2719.266,471.4184;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;265;3724.146,1345.072;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;2831.757,1137.729;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;256;3761.965,1022.69;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;261;3758.925,1226.887;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;45;354.8613,1333.603;Float;False;Property;_BColorMix;B-Color/Mix;44;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;43;332.0548,397.4253;Float;False;Property;_RColorMix;R-Color/Mix;22;0;Create;True;0;0;False;0;0.9558824,0.9558824,0.9558824,0;0.5032812,0.5588235,0.4150086,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;12;744.8758,-342.3485;Float;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;48;263.8178,1063.151;Float;True;Property;_GAlbedoCutout;G-Albedo/Cutout;30;1;[NoScaleOffset];Create;True;0;0;False;0;None;00984d1eedeedfd419236feb11430537;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;44;327.3091,862.2882;Float;False;Property;_GColorMix;G-Color/Mix;33;0;Create;True;0;0;False;0;0.9558824,0.9558824,0.9558824,0.978;0.2941176,0.2941176,0.2941176,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;42;323.4925,-38.75996;Float;False;Property;_BaseColorInclusion;Base-Color/Inclusion;16;0;Create;True;0;0;False;0;1,1,1,1;0.25,0.25,0.25,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;50;344.7202,1507.135;Float;True;Property;_BAlbedoCutout;B-Albedo/Cutout;41;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;95;2816.115,190.899;Float;True;Property;_BaseMetalRRoughGAORHeightA;Base Metal(R)-Rough(G)AO(R)-Height(A);15;1;[NoScaleOffset];Create;True;0;0;False;0;None;d98c8930ef19bd940b65ddda87928c75;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;93;295.238,174.0405;Float;True;Property;_BaseAlbedo;Base-Albedo;13;1;[NoScaleOffset];Create;True;0;0;False;0;None;ed08309d24fd0b64d9102dadc3a87c4e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;13;315.0959,603.2919;Float;True;Property;_RAlbedoCutout;R-Albedo/Cutout;19;1;[NoScaleOffset];Create;True;0;0;False;0;None;00984d1eedeedfd419236feb11430537;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;255;3916.568,977.822;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;1013.493,535.1805;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;262;3913.528,1182.019;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;1551.239,1555.915;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;266;3906.905,1379.39;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;135;991.395,93.74289;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LayeredBlendNode;54;3488.596,454.762;Float;False;6;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;143;1548.517,1738.417;Float;False;Constant;_Vector0;Vector 0;43;0;Create;True;0;0;False;0;0.33,0.33,0.33;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;1345.827,1217.759;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;101;3522.538,1804.862;Float;False;Property;_BaseHeightAmount;Base-Height-Amount;17;0;Create;True;0;0;False;0;0;2.1;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;267;4084.078,1381.399;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;259;4093.741,979.8313;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;153;1074.693,757.2905;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;3504.318,1707.582;Float;False;Property;_BaseHeightOffset;Base-Height-Offset;18;0;Create;True;0;0;False;0;0;0;-4;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;263;4090.7,1184.028;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;152;1180.614,1574.526;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LayeredBlendNode;142;2116.818,1743.154;Float;False;6;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;151;1215.994,1352.1;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;66;4016.614,473.4911;Float;False;False;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;3954.766,1693.539;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;146;1945.616,856.6526;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;268;4259.056,1521.361;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;260;4268.72,1119.793;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;65;4276.021,575.587;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;68;4021.971,624.5123;Float;False;False;False;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;72;3313.679,1223.609;Float;True;Property;_BNormal;B-Normal;42;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;136;2736.97,1667.49;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;145;2300.398,1513.944;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;94;2955.711,434.5353;Float;True;Property;_Base_NormalMap;Base_NormalMap;14;1;[NoScaleOffset];Create;True;0;0;False;0;None;9c409e10a4c775f4ebb8834ea1bc9483;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;111;4274.434,1718.595;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;264;4265.678,1323.99;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;71;3124.398,996.2607;Float;True;Property;_GNormal;G-Normal;31;1;[NoScaleOffset];Create;True;0;0;False;0;None;2ff80c276126bf1429db5b54376b7531;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;15;3027.77,700.8527;Float;True;Property;_RNormal;R-Normal;20;1;[NoScaleOffset];Create;True;0;0;False;0;None;477f9af4c0593364bbf065b0a20d9ca9;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;63;4555.661,546.2833;Float;False;Property;_RoughnessMode;Roughness Mode;10;0;Create;True;0;0;False;0;0;1;1;True;;Toggle;2;Key0;Key1;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;67;4017.474,362.1758;Float;False;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;3499.952,-41.88916;Float;False;Property;_BaseLayerMix;Base-Layer-Mix;2;0;Create;True;0;0;False;0;1;0.608;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LayeredBlendNode;11;3679.913,196.9818;Float;False;6;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LayeredBlendNode;270;5052.853,1340.4;Float;False;6;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LayeredBlendNode;55;3801.439,773.0779;Float;False;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;90;4462.789,964.4423;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;232;5140.281,877.8403;Float;False;Property;_GlobalSmoothnessMultiplier;GlobalSmoothnessMultiplier;3;0;Create;True;0;0;False;0;1;0.06;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;234;5199.449,775.7413;Float;False;Property;_GlobalMetallicMultiplier;GlobalMetallicMultiplier;4;0;Create;True;0;0;False;0;1;0.64;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;70;4286.145,703.6776;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;88;4279.526,22.05822;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;150;4221.924,746.0984;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;235;5643.449,735.7413;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;233;5694.519,870.8193;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LayeredBlendNode;148;3223.562,1557.598;Float;False;6;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;69;4673.619,690.8297;Float;False;Property;_InvertAO;Invert AO;11;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;5666.04,985.3079;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;225;4775.771,1102.468;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;224;5205.463,1181.622;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;223;4985.375,1210.973;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;6875.063,700.6654;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;MEGA_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;0;1.85;1.48;48.38;False;0.433;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;5;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;5;0
WireConnection;18;0;17;0
WireConnection;26;0;25;0
WireConnection;108;0;110;0
WireConnection;227;0;4;0
WireConnection;227;1;108;0
WireConnection;226;0;108;0
WireConnection;226;1;18;0
WireConnection;228;0;108;0
WireConnection;228;1;26;0
WireConnection;32;0;2;0
WireConnection;32;1;228;0
WireConnection;24;0;2;0
WireConnection;24;1;226;0
WireConnection;3;0;2;0
WireConnection;3;1;227;0
WireConnection;180;0;181;0
WireConnection;22;0;24;2
WireConnection;22;1;19;0
WireConnection;6;0;3;1
WireConnection;6;1;7;0
WireConnection;30;0;32;3
WireConnection;30;1;27;0
WireConnection;182;0;108;0
WireConnection;182;1;180;0
WireConnection;184;0;183;0
WireConnection;178;0;177;0
WireConnection;29;0;30;0
WireConnection;29;1;27;0
WireConnection;29;2;28;0
WireConnection;9;0;6;0
WireConnection;9;1;7;0
WireConnection;9;2;10;0
WireConnection;21;0;22;0
WireConnection;21;1;19;0
WireConnection;21;2;20;0
WireConnection;179;0;178;0
WireConnection;179;1;108;0
WireConnection;60;1;182;0
WireConnection;185;0;184;0
WireConnection;185;1;108;0
WireConnection;23;0;22;0
WireConnection;23;1;21;0
WireConnection;8;0;6;0
WireConnection;8;1;9;0
WireConnection;31;0;30;0
WireConnection;31;1;29;0
WireConnection;129;0;60;4
WireConnection;129;1;127;0
WireConnection;61;1;185;0
WireConnection;14;1;179;0
WireConnection;114;0;115;0
WireConnection;114;1;23;0
WireConnection;113;0;8;0
WireConnection;113;1;112;0
WireConnection;117;0;31;0
WireConnection;117;1;116;0
WireConnection;120;0;61;4
WireConnection;120;1;119;0
WireConnection;128;0;129;0
WireConnection;128;1;126;0
WireConnection;133;0;14;4
WireConnection;133;1;131;0
WireConnection;164;0;113;0
WireConnection;162;0;114;0
WireConnection;163;0;117;0
WireConnection;132;0;133;0
WireConnection;132;1;130;0
WireConnection;265;0;258;0
WireConnection;124;0;121;0
WireConnection;124;1;120;0
WireConnection;256;0;128;0
WireConnection;256;1;258;0
WireConnection;261;1;258;0
WireConnection;12;0;164;0
WireConnection;12;1;162;0
WireConnection;12;2;163;0
WireConnection;48;1;182;0
WireConnection;50;1;185;0
WireConnection;95;1;108;0
WireConnection;93;1;108;0
WireConnection;13;1;179;0
WireConnection;255;0;132;0
WireConnection;255;1;256;0
WireConnection;47;0;43;0
WireConnection;47;1;13;0
WireConnection;262;0;128;0
WireConnection;262;1;261;0
WireConnection;51;0;45;0
WireConnection;51;1;50;0
WireConnection;266;0;265;0
WireConnection;266;1;124;0
WireConnection;135;0;42;0
WireConnection;135;1;93;0
WireConnection;54;0;12;0
WireConnection;54;1;95;0
WireConnection;54;2;14;0
WireConnection;54;3;60;0
WireConnection;54;4;61;0
WireConnection;49;0;44;0
WireConnection;49;1;48;0
WireConnection;267;0;266;0
WireConnection;259;0;255;0
WireConnection;153;0;43;4
WireConnection;263;0;262;0
WireConnection;152;0;45;4
WireConnection;142;0;143;0
WireConnection;142;1;135;0
WireConnection;142;2;47;0
WireConnection;142;3;49;0
WireConnection;142;4;51;0
WireConnection;151;0;44;4
WireConnection;66;0;54;0
WireConnection;91;0;95;4
WireConnection;91;1;101;0
WireConnection;146;0;47;0
WireConnection;146;1;142;0
WireConnection;146;2;153;0
WireConnection;268;0;267;0
WireConnection;268;1;124;0
WireConnection;260;0;259;0
WireConnection;260;1;128;0
WireConnection;65;0;66;0
WireConnection;68;0;54;0
WireConnection;72;1;185;0
WireConnection;136;0;51;0
WireConnection;136;1;142;0
WireConnection;136;2;152;0
WireConnection;145;0;49;0
WireConnection;145;1;142;0
WireConnection;145;2;151;0
WireConnection;94;1;108;0
WireConnection;111;0;91;0
WireConnection;111;1;103;0
WireConnection;264;0;263;0
WireConnection;264;1;128;0
WireConnection;71;1;182;0
WireConnection;15;1;179;0
WireConnection;63;1;66;0
WireConnection;63;0;65;0
WireConnection;67;0;54;0
WireConnection;11;0;12;0
WireConnection;11;1;135;0
WireConnection;11;2;146;0
WireConnection;11;3;145;0
WireConnection;11;4;136;0
WireConnection;270;0;12;0
WireConnection;270;1;111;0
WireConnection;270;2;260;0
WireConnection;270;3;264;0
WireConnection;270;4;268;0
WireConnection;55;0;12;0
WireConnection;55;1;94;0
WireConnection;55;2;15;0
WireConnection;55;3;71;0
WireConnection;55;4;72;0
WireConnection;70;0;68;0
WireConnection;88;0;135;0
WireConnection;88;1;11;0
WireConnection;88;2;89;0
WireConnection;150;0;94;0
WireConnection;150;1;55;0
WireConnection;150;2;89;0
WireConnection;235;0;67;0
WireConnection;235;1;234;0
WireConnection;233;0;63;0
WireConnection;233;1;232;0
WireConnection;148;0;12;0
WireConnection;148;1;93;4
WireConnection;148;2;13;4
WireConnection;148;3;48;4
WireConnection;148;4;50;4
WireConnection;69;1;68;0
WireConnection;69;0;70;0
WireConnection;118;0;90;0
WireConnection;118;1;270;0
WireConnection;225;0;89;0
WireConnection;224;0;223;0
WireConnection;224;2;101;0
WireConnection;223;0;111;0
WireConnection;223;1;225;0
WireConnection;0;0;88;0
WireConnection;0;1;150;0
WireConnection;0;3;235;0
WireConnection;0;4;233;0
WireConnection;0;5;69;0
WireConnection;0;10;148;0
WireConnection;0;11;118;0
ASEEND*/
//CHKSM=FCDBCB7A8B4AF19F551D3425068AC937B571AAC7
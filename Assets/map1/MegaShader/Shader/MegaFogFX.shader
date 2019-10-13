// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "  "
{
	Properties
	{
		_RemapMax("RemapMax", Range( 0 , 5000)) = 5
		_RemapHeightMax("RemapHeightMax", Range( 0 , 10)) = 6.514321
		_FogColorAmount("FogColor/Amount", Color) = (0,0,0,0)
		_BaseColor("BaseColor", Color) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
		};

		uniform float4 _BaseColor;
		uniform float4 _FogColorAmount;
		uniform float _RemapHeightMax;
		uniform float _RemapMax;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 ase_worldPos = i.worldPos;
			float4 lerpResult34 = lerp( _BaseColor , _FogColorAmount , ( _FogColorAmount.a * ( ( ( 1.0 - (0.0 + (ase_vertex3Pos.y - 0.0) * (1.0 - 0.0) / (_RemapHeightMax - 0.0)) ) + (0.0 + (distance( _WorldSpaceCameraPos , ase_worldPos ) - 0.0) * (1.0 - 0.0) / (_RemapMax - 0.0)) ) / 2.0 ) ));
			o.Emission = lerpResult34.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
-30;483;1906;1014;1389.955;428.7918;1.413411;True;False
Node;AmplifyShaderEditor.WorldSpaceCameraPos;17;-819.1542,-45.39162;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;21;-385.936,-58.2562;Float;False;Property;_RemapHeightMax;RemapHeightMax;1;0;Create;True;0;0;False;0;6.514321;0.51;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;19;-277.5705,12.84869;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;30;-809.0433,175.2875;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;10;-458.0919,53.89551;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-765.1597,383.4875;Float;False;Property;_RemapMax;RemapMax;0;0;Create;True;0;0;False;0;5;124;0;5000;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;20;35.61808,-32.84531;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;25;276.2414,9.796947;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;16;-129.3831,208.8141;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;100;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;197.5004,310.8013;Float;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;453.2811,85.19651;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;27;719.2362,188.8888;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;31;438.9987,-132.8361;Float;False;Property;_FogColorAmount;FogColor/Amount;2;0;Create;True;0;0;False;0;0,0,0,0;0.8014706,0.3889489,0.397484,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;33;419.2107,-308.6519;Float;False;Property;_BaseColor;BaseColor;3;0;Create;True;0;0;False;0;0,0,0,0;0.02422145,0.4117647,0.07500303,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;776.8038,56.00818;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;34;932.2792,-211.1265;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1121.925,-34.87867;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;  ;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;17;0
WireConnection;10;1;30;0
WireConnection;20;0;19;2
WireConnection;20;2;21;0
WireConnection;25;0;20;0
WireConnection;16;0;10;0
WireConnection;16;2;18;0
WireConnection;24;0;25;0
WireConnection;24;1;16;0
WireConnection;27;0;24;0
WireConnection;27;1;28;0
WireConnection;35;0;31;4
WireConnection;35;1;27;0
WireConnection;34;0;33;0
WireConnection;34;1;31;0
WireConnection;34;2;35;0
WireConnection;0;2;34;0
ASEEND*/
//CHKSM=16A37486A668A2DA136654E7A23B8741A14A9DEA
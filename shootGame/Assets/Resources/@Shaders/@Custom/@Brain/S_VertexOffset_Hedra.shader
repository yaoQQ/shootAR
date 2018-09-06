// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Shader Forge/S_VertexOffset_Hedra" 
{
    Properties 
    {
        _Color ("Color", Color) = (0.07843138,0.3921569,0.7843137,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _EmissStrength ("EmissStrength", Float ) = 8
        _AlphaStrength ("AlphaStrength", Float ) = 2
        _VertexOffset_Str ("VertexOffset_Str", Float ) = 0.5
        _OffsetSpeed ("OffsetSpeed", Float ) = 1
        _VertexOffset_Dir ("VertexOffset_Dir", Vector) = (0.1,0.1,1,0)
        _ShinySpeed ("ShinySpeed", Float ) = 30
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }

    SubShader 
    {
        Tags 
        {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }

        Pass 
        {

            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            //#pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            //#pragma target 3.0
            //#pragma glsl

            uniform float4 _TimeEditor;
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _EmissStrength;
            uniform float _AlphaStrength;
            uniform float _VertexOffset_Str;
            uniform float _OffsetSpeed;
            uniform float4 _VertexOffset_Dir;
            uniform float _ShinySpeed;

            struct VertexInput 
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };

            struct VertexOutput 
            {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float4 vertexColor : COLOR;
            };

            VertexOutput vert (VertexInput v) 
            {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 _MainTex_var = tex2Dlod(_MainTex,float4(TRANSFORM_TEX(o.uv0, _MainTex),0.0,0));
                float4 node_2761 = _Time + _TimeEditor;
                v.vertex.xyz += (((_MainTex_var.g*(v.normal*(sin((node_2761.g*_OffsetSpeed))+0.5)))*_VertexOffset_Dir.rgb)*_VertexOffset_Str);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }

            float4 frag(VertexOutput i, float facing : VFACE) : COLOR 
            {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
////// Lighting:
////// Emissive:
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float4 node_2761 = _Time + _TimeEditor;
                float3 emissive = ((((_Color.rgb*_MainTex_var.r)*_EmissStrength)*i.vertexColor.rgb)*((((sin((node_2761.g*_ShinySpeed))*0.5)+1.0)/1.0)*2.0));
                float3 finalColor = emissive;
                return fixed4(finalColor,(i.vertexColor.a*(_MainTex_var.r*_AlphaStrength)));
            }
            ENDCG
        }

    }
    //FallBack "Diffuse"
}
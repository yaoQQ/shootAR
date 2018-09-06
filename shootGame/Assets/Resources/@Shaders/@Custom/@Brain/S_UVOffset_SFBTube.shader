// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Shader Forge/S_UVOffset_SFBTube" 
{
    Properties 
    {
        _Color ("Color", Color) = (0.07843138,0.3921569,0.7843137,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _OffsetSpeed_A ("OffsetSpeed_A", Float ) = 1
        _MainStrength ("MainStrength", Float ) = 4
        _MainTex_copy ("MainTex_copy", 2D) = "white" {}
        _OffsetSpeed_B ("OffsetSpeed_B", Float ) = 0.5
        _Mask ("Mask", 2D) = "white" {}
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

            Tags 
            {
                "LightMode"="ForwardBase"
            }
            Blend One One
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            //#pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            //#pragma target 3.0

            uniform float4 _TimeEditor;
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _OffsetSpeed_A;
            uniform float _MainStrength;
            uniform sampler2D _MainTex_copy; uniform float4 _MainTex_copy_ST;
            uniform float _OffsetSpeed_B;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;

            struct VertexInput 
            {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput 
            {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) 
            {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR 
            {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
////// Emissive:
                float4 node_4985 = _Time + _TimeEditor;
                float2 node_7767 = (i.uv0*float2(1,1));
                float2 node_2732 = (node_7767+(node_4985.g*_OffsetSpeed_A)*float2(0,1));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_2732, _MainTex));
                float2 node_8416 = (node_7767+(node_4985.g*_OffsetSpeed_B)*float2(0,1));
                float4 _MainTex_copy_var = tex2D(_MainTex_copy,TRANSFORM_TEX(node_8416, _MainTex_copy));
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                float3 emissive = (((_Color.rgb*((_MainTex_var.r+_MainTex_copy_var.g)*_MainStrength))*_Mask_var.g)*i.vertexColor.rgb);
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    //FallBack "Diffuse"
}
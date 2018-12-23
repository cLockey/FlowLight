// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/MoveLightImage"  
{  
    Properties  
    {  
        //主纹理  
        _MainTex ("Texture", 2D) = "white" {}  
        //灯光纹理  
        _LightTex("Light Texture",2D)="white"{}  
        //遮罩纹理  
        //_MaskTex("Mask Texture",2D)="white"{} 
		_LightPower("Light Power",Range(0,5)) = 1

		_TimeOffset("TimeOffset", float) = 0

		_Enabled("Enabled", int) = 1
    }  
    SubShader  
    {  
        Tags {"Queue"="Transparent" "RenderType"="Transparent" }  
        LOD 100  
        //透明混合  
        Blend SrcAlpha OneMinusSrcAlpha  
  
        Pass  
        {  
            CGPROGRAM  
            #pragma vertex vert  
            #pragma fragment frag  
             
            #include "UnityCG.cginc"  
  
            struct appdata  
            {  
                float4 vertex : POSITION;  
                float2 uv : TEXCOORD0;  
            };  
  
            struct v2f  
            {  
                float2 uv : TEXCOORD0;  
                UNITY_FOG_COORDS(1)  
                float4 vertex : SV_POSITION;  
            };  
  
            sampler2D _MainTex;  
            float4 _MainTex_ST;  
            sampler2D _LightTex;  
            //sampler2D _MaskTex;  
            fixed4 _Color;  
			float _LightPower;
			float _TimeOffset;
			int _Enabled;
  
            v2f vert (appdata v)  
            {  
                v2f o;  
                o.vertex = UnityObjectToClipPos(v.vertex);  
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);   
                return o;  
            }  
              
            fixed4 frag (v2f i) : SV_Target  
            {  
				if(_Enabled == 0)
					return tex2D(_MainTex, i.uv);
                //灯光贴图 取一半UV  
                float2 uv=i.uv*0.5;  
                //不断改变uv的x轴，让他往x轴方向移动,_Time为shader的时间函数，会一直执行  
                uv.x+=-_TimeOffset;  
                //取灯光贴图的alpha值,黑色为0，白色为1   
                fixed lightTexAlpha=tex2D(_LightTex, uv).a;  
                //获取遮罩贴图的alpha值，黑色为0，白色为1 这里的uv和上面的uv是调用的不一样的函数  
                //fixed maskA=tex2D(_MaskTex,i.uv).a;  
  
                //主纹理+灯光贴图*遮罩贴图 简单原理任何数*0为0   这样就避免了遮罩外出现不协调灯光贴图  
				fixed4 mainCol = tex2D(_MainTex, i.uv);
                fixed4 col = mainCol;
				col.rgb = mainCol.rgb + fixed3(lightTexAlpha,lightTexAlpha,lightTexAlpha) * mainCol.a * _LightPower;//maskA*0.6;    
				col.a = col.a;
                return col;
            }  
            ENDCG  
        }  
    }  
}  
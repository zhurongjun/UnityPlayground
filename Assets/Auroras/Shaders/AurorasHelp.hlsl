﻿#ifndef AURORAS_HELP_INCLUDE
#define AURORAS_HELP_INCLUDE

// 噪声函数(黑白电视)
inline float hash21 (float2 n) { return frac(sin(dot(n, float2(12.9898, 4.1414))) * 43758.5453); }

// V形函数, 和sin类似，只不过他的函数图像是尖锐的搓衣板形
inline float tri (float n) { return abs(frac(n) - 0.5); }

// 二维的V形函数, 不仅会在X轴形成明暗条纹，在Y轴上也会施加一个波浪一样的效果
inline float tri21 (float2 uv) { return tri(uv.x + tri(uv.y)); }

// 二维的V形函数, 只不过这里xy通道进行了垂直的叠加
inline float2 tri22 (float2 uv) { return float2(tri21(uv.xy), tri21(uv.yx)); }

// 二维的sin函数, 逻辑同tri21
inline float sin21 (float2 uv) { return sin(uv.x + sin(uv.y)); }

// 二维的sin函数, 逻辑同tri22
inline float2 sin22 (float2 uv) { return float2(sin21(uv.xy), sin21(uv.yx)); }

// 旋转矩阵, 下面要用
float2x2 rotate_mat = float2x2(0.970, 0.242, -0.242, 0.970);

// 经过 UV扰动 和 fbm 的 tri21 噪声
// the book of shader中译: https://thebookofshaders.com/?lan=ch
// UV扰动: https://zhuanlan.zhihu.com/p/423340977
// 噪声: https://thebookofshaders.com/11/?lan=ch
// fbm(分形布朗运动): https://thebookofshaders.com/13/?lan=ch
float triNoise2 (float2 uv, float time, float fbm_attenuation = 0.8f, int fbm_step = 5)
{
	float v = 0.0;
	// fbm的初始强度
	float fbm_factor = 1;
	// 所有fbm叠加的总和, 用于将结果压到[0, 1]的区间内
	float fbm_factor_sum = 0;
	// 用于采样扰动量的坐标值
	float2 warp_uv = uv;

	for (int i = 0; i < fbm_step; ++i)
	{
		// 计算扰动uv
		float2 warp_vec = tri22(warp_uv);

		// 施加扰动, time用来制作流动效果
		uv += warp_vec + time;

		// 采样noise结果，施加到结果上去
		v += tri21(uv) * fbm_factor;

		// 累计fbm强度
		fbm_factor_sum += fbm_factor;

		// 更新fbm强度
		fbm_factor *= fbm_attenuation;

		// 更新下一次扰动量的采样位置
		warp_uv = warp_uv * 1.8 + 0.2;

		// 更新下一次uv采样的位置(做一次缩放，然后旋转换个方向流动)
		uv = mul(uv * 1.2, rotate_mat);
	}

	return v / fbm_factor_sum;
}

// 经过 UV扰动 和 fbm 的 tri21 噪声(sin款)
float sinNoise2 (float2 uv, float time, float fbm_attenuation = 0.9f, int fbm_step = 5)
{
	float v = 0.0;
	// fbm的初始强度
	float fbm_factor = 1;
	// 所有fbm叠加的总和, 用于将结果压到[0, 1]的区间内
	float fbm_factor_sum = 0;
	// 用于采样扰动量的坐标值
	float2 warp_uv = uv;

	for (int i = 0; i < fbm_step; ++i)
	{
		// 计算扰动uv
		float2 warp_vec = sin22(warp_uv);

		// 施加扰动, time用来制作流动效果
		uv += warp_vec + time;

		// 采样noise结果，施加到结果上去
		v += sin21(uv) * fbm_factor;

		// 累计fbm强度
		fbm_factor_sum += fbm_factor;

		// 更新fbm强度
		fbm_factor *= fbm_attenuation;

		// 更新下一次扰动量的采样位置
		warp_uv = warp_uv * 1.8 + 0.2;

		// 更新下一次uv采样的位置(做一次缩放，然后旋转换个方向流动)
		uv = mul(uv * 1.2, rotate_mat);
	}

	return v / fbm_factor_sum;
}

#endif

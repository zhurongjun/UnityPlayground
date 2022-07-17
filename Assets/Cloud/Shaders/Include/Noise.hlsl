#ifndef NOISE_INCLUDED
#define NOISE_INCLUDED

inline bool isNaNOrInf (float x)
{
	return (asuint(x) & 0x7FFFFFFF) >= 0x7F800000;
}

// GoldNoise: https://www.shadertoy.com/view/wtsSW4
const float PHI = 1.61803398874989484820459; // Φ = Golden Ratio 

// 2D GoldNoise
inline float goldNoise21 (float2 pos, float seed = 0)
{
	float tanVal = tan(distance(pos * PHI, pos) * (seed + 10));
	return frac((isNaNOrInf(tanVal) ? 0 : tanVal) * pos.x);
}
inline float2 goldNoise22 (float2 pos, float seed = 0)
{
	return float2(
		goldNoise21(pos, seed + 0.0),
		goldNoise21(pos, seed + 0.1)
		);
}
inline float3 goldNoise23 (float2 pos, float seed = 0)
{
	return float3(
		goldNoise21(pos, seed + 0.0),
		goldNoise21(pos, seed + 0.1),
		goldNoise21(pos, seed + 0.2)
		);
}
inline float4 goldNoise24 (float2 pos, float seed = 0)
{
	return float4(
		goldNoise21(pos, seed + 0.0),
		goldNoise21(pos, seed + 0.1),
		goldNoise21(pos, seed + 0.2),
		goldNoise21(pos, seed + 0.3)
		);
}

// 3D GoldNoise
inline float goldNoise31 (float3 pos, float seed = 0)
{
	float tanVal = tan(distance(pos * PHI, pos) * (seed + 10));
	return frac((isNaNOrInf(tanVal) ? 0 : tanVal) * pos.x);
}
inline float2 goldNoise32 (float3 pos, float seed = 0)
{
	return float2(
		goldNoise31(pos, seed + 0.0),
		goldNoise31(pos, seed + 0.1)
		);
}
inline float3 goldNoise33 (float3 pos, float seed = 0)
{
	return float3(
		goldNoise31(pos, seed + 0.0),
		goldNoise31(pos, seed + 0.1),
		goldNoise31(pos, seed + 0.2)
		);
}
inline float4 goldNoise34 (float3 pos, float seed = 0)
{
	return float4(
		goldNoise31(pos, seed + 0.0),
		goldNoise31(pos, seed + 0.1),
		goldNoise31(pos, seed + 0.2),
		goldNoise31(pos, seed + 0.3)
		);
}

// 2D perlin noise
float perlinNoise21 (float2 uv, int2 gridCount, float seed = 0)
{
	// uv to grid space
	uv *= gridCount;
	float2 grid = floor(uv);
	float2 gridUV = frac(uv);

	// get grid point(repeat on edge)
	float2 p0 = (grid + float2(0, 0)) % gridCount;
	float2 p1 = (grid + float2(1, 0)) % gridCount;
	float2 p2 = (grid + float2(0, 1)) % gridCount;
	float2 p3 = (grid + float2(1, 1)) % gridCount;

	// get grid gradient
	float2 g0 = normalize(goldNoise22(p0 + 0.1f, seed) * 2 - 1);
	float2 g1 = normalize(goldNoise22(p1 + 0.1f, seed) * 2 - 1);
	float2 g2 = normalize(goldNoise22(p2 + 0.1f, seed) * 2 - 1);
	float2 g3 = normalize(goldNoise22(p3 + 0.1f, seed) * 2 - 1);

	// calc gradient vector
	float v0 = dot(gridUV - float2(0, 0), g0) * 0.5 + 0.5;
	float v1 = dot(gridUV - float2(1, 0), g1) * 0.5 + 0.5;
	float v2 = dot(gridUV - float2(0, 1), g2) * 0.5 + 0.5;
	float v3 = dot(gridUV - float2(1, 1), g3) * 0.5 + 0.5;

	// calc gradient noise
	float2 u = gridUV * gridUV * (3.0 - 2.0 * gridUV);
	float x0 = lerp(v0, v1, u.x);
	float x1 = lerp(v2, v3, u.x);
	float y = lerp(x0, x1, u.y);

	return y;
}
inline float2 perlinNoise22 (float2 uv, int2 gridCount, float seed = 0)
{
	return float2(
		perlinNoise21(uv, gridCount, seed + 0.0),
		perlinNoise21(uv, gridCount, seed + 0.1)
		);
}
inline float3 perlinNoise23 (float2 uv, int2 gridCount, float seed = 0)
{
	return float3(
		perlinNoise21(uv, gridCount, seed + 0.0),
		perlinNoise21(uv, gridCount, seed + 0.1),
		perlinNoise21(uv, gridCount, seed + 0.2)
		);
}
inline float4 perlinNoise24 (float2 uv, int2 gridCount, float seed = 0)
{
	return float4(
		perlinNoise21(uv, gridCount, seed + 0.0),
		perlinNoise21(uv, gridCount, seed + 0.1),
		perlinNoise21(uv, gridCount, seed + 0.2),
		perlinNoise21(uv, gridCount, seed + 0.3)
		);
}

// 3D perlin noise
float perlinNoise31 (float3 uv, int3 gridCount, float seed = 0)
{
	// uv to grid space
	uv *= gridCount;
	float3 grid = floor(uv);
	float3 gridUV = frac(uv);

	// get grid point(repeat on edge)
	float3 p0 = (grid + float3(0, 0, 0)) % gridCount;
	float3 p1 = (grid + float3(1, 0, 0)) % gridCount;
	float3 p2 = (grid + float3(0, 1, 0)) % gridCount;
	float3 p3 = (grid + float3(1, 1, 0)) % gridCount;
	float3 p4 = (grid + float3(0, 0, 1)) % gridCount;
	float3 p5 = (grid + float3(1, 0, 1)) % gridCount;
	float3 p6 = (grid + float3(0, 1, 1)) % gridCount;
	float3 p7 = (grid + float3(1, 1, 1)) % gridCount;

	// get grid gradient
	float3 g0 = normalize(goldNoise33(p0 + 0.1f, seed) * 2 - 1);
	float3 g1 = normalize(goldNoise33(p1 + 0.1f, seed) * 2 - 1);
	float3 g2 = normalize(goldNoise33(p2 + 0.1f, seed) * 2 - 1);
	float3 g3 = normalize(goldNoise33(p3 + 0.1f, seed) * 2 - 1);
	float3 g4 = normalize(goldNoise33(p4 + 0.1f, seed) * 2 - 1);
	float3 g5 = normalize(goldNoise33(p5 + 0.1f, seed) * 2 - 1);
	float3 g6 = normalize(goldNoise33(p6 + 0.1f, seed) * 2 - 1);
	float3 g7 = normalize(goldNoise33(p7 + 0.1f, seed) * 2 - 1);

	// calc gradient vector
	float v0 = dot(gridUV - float3(0, 0, 0), g0) * 0.5 + 0.5;
	float v1 = dot(gridUV - float3(1, 0, 0), g1) * 0.5 + 0.5;
	float v2 = dot(gridUV - float3(0, 1, 0), g2) * 0.5 + 0.5;
	float v3 = dot(gridUV - float3(1, 1, 0), g3) * 0.5 + 0.5;
	float v4 = dot(gridUV - float3(0, 0, 1), g4) * 0.5 + 0.5;
	float v5 = dot(gridUV - float3(1, 0, 1), g5) * 0.5 + 0.5;
	float v6 = dot(gridUV - float3(0, 1, 1), g6) * 0.5 + 0.5;
	float v7 = dot(gridUV - float3(1, 1, 1), g7) * 0.5 + 0.5;

	// calc gradient noise
	float3 u = gridUV * gridUV * (3.0 - 2.0 * gridUV);
	float x0 = lerp(v0, v1, u.x);
	float x1 = lerp(v2, v3, u.x);
	float x2 = lerp(v4, v5, u.x);
	float x3 = lerp(v6, v7, u.x);
	float y0 = lerp(x0, x1, u.y);
	float y1 = lerp(x2, x3, u.y);
	float z = lerp(y0, y1, u.z);

	return z;
}
inline float2 perlinNoise32 (float3 uv, int3 gridCount, float seed = 0)
{
	return float2(
		perlinNoise31(uv, gridCount, seed + 0.0),
		perlinNoise31(uv, gridCount, seed + 0.1)
		);
}
inline float3 perlinNoise33 (float3 uv, int3 gridCount, float seed = 0)
{
	return float3(
		perlinNoise31(uv, gridCount, seed + 0.0),
		perlinNoise31(uv, gridCount, seed + 0.1),
		perlinNoise31(uv, gridCount, seed + 0.2)
		);
}
inline float4 perlinNoise34 (float3 uv, int3 gridCount, float seed = 0)
{
	return float4(
		perlinNoise31(uv, gridCount, seed + 0.0),
		perlinNoise31(uv, gridCount, seed + 0.1),
		perlinNoise31(uv, gridCount, seed + 0.2),
		perlinNoise31(uv, gridCount, seed + 0.3)
		);
}

// 2D Voronoi noise
float voronoiNoise21 (float2 uv, int2 gridCount, float seed = 0)
{
	// uv to grid space
	uv *= gridCount;
	float2 grid = floor(uv);

	// calc min dis 
	float minDis = 10;
	UNITY_UNROLL
	for (int y = -1; y <= 1; ++y)
	{
		UNITY_UNROLL
		for (int x = -1; x <= 1; ++x)
		{
			float2 curGrid = grid + float2(x, y);
			float2 repeatGrid = (curGrid + gridCount) % gridCount;

			float2 gridCenter = curGrid + goldNoise22(repeatGrid + 0.1f, seed);
			float curDis = distance(uv, gridCenter);
			minDis = min(minDis, curDis);
		}
	}

	return minDis;
}
inline float2 voronoiNoise22 (float2 uv, int2 gridCount, float seed = 0)
{
	return float2(
		voronoiNoise21(uv, gridCount, seed + 0.0),
		voronoiNoise21(uv, gridCount, seed + 0.1)
		);
}
inline float3 voronoiNoise23 (float2 uv, int2 gridCount, float seed = 0)
{
	return float3(
		voronoiNoise21(uv, gridCount, seed + 0.0),
		voronoiNoise21(uv, gridCount, seed + 0.1),
		voronoiNoise21(uv, gridCount, seed + 0.2)
		);
}
inline float4 voronoiNoise24 (float2 uv, int2 gridCount, float seed = 0)
{
	return float4(
		voronoiNoise21(uv, gridCount, seed + 0.0),
		voronoiNoise21(uv, gridCount, seed + 0.1),
		voronoiNoise21(uv, gridCount, seed + 0.2),
		voronoiNoise21(uv, gridCount, seed + 0.3)
		);
}

// 3D voronoi noise
float voronoiNoise31 (float3 uv, int3 gridCount, float seed = 0)
{
	// uv to grid space
	uv *= gridCount;
	float3 grid = floor(uv);

	// calc min dis 
	float minDis = 10;
	UNITY_UNROLL
	for (int z = -1; z <= 1; ++z)
	{
		UNITY_UNROLL
		for (int y = -1; y <= 1; ++y)
		{
			UNITY_UNROLL
			for (int x = -1; x <= 1; ++x)
			{
				float3 curGrid = grid + float3(x, y, z);
				float3 repeatGrid = (curGrid + gridCount) % gridCount;

				float3 gridCenter = curGrid + goldNoise33(repeatGrid + 0.1f, seed);
				float curDis = distance(uv, gridCenter);
				minDis = min(minDis, curDis);
			}
		}
	}

	return minDis;
}
inline float2 voronoiNoise32 (float3 uv, int3 gridCount, float seed = 0)
{
	return float2(
		voronoiNoise31(uv, gridCount, seed + 0.0),
		voronoiNoise31(uv, gridCount, seed + 0.1)
		);
}
inline float3 voronoiNoise33 (float3 uv, int3 gridCount, float seed = 0)
{
	return float3(
		voronoiNoise31(uv, gridCount, seed + 0.0),
		voronoiNoise31(uv, gridCount, seed + 0.1),
		voronoiNoise31(uv, gridCount, seed + 0.2)
		);
}
inline float4 voronoiNoise34 (float3 uv, int3 gridCount, float seed = 0)
{
	return float4(
		voronoiNoise31(uv, gridCount, seed + 0.0),
		voronoiNoise31(uv, gridCount, seed + 0.1),
		voronoiNoise31(uv, gridCount, seed + 0.2),
		voronoiNoise31(uv, gridCount, seed + 0.3)
		);
}

// 2D voronoi noise inverse(distance to cell edge)
float voronoiNoiseInv21 (float2 uv, int2 gridCount, float seed = 0)
{
	// uv to grid space
	uv *= gridCount;
	float2 grid = floor(uv);

	// cache noise
	float2 noiseCache[9];
	UNITY_UNROLL
	for (int y = -1; y <= 1; ++y)
	{
		UNITY_UNROLL
		for (int x = -1; x <= 1; ++x)
		{
			int idx = (y + 1) * 3 + (x + 1);
			float2 curGrid = grid + float2(x, y);
			float2 repeatGrid = (curGrid + gridCount) % gridCount;
			noiseCache[idx] = goldNoise22(repeatGrid + 0.1f, seed);
		}
	}

	// find closest grid center 
	float minDis = 10;
	float2 closestCell;
	float2 closestCellVec;
	UNITY_UNROLL
	for (int y = -1; y <= 1; ++y)
	{
		UNITY_UNROLL
		for (int x = -1; x <= 1; ++x)
		{
			int idx = (y + 1) * 3 + (x + 1);
			float2 curGrid = grid + float2(x, y);

			float2 gridCenter = curGrid + noiseCache[idx];
			float2 cellVec = uv - gridCenter;
			float curDis = length(cellVec);

			if (curDis < minDis)
			{
				minDis = curDis;
				closestCell = gridCenter;
				closestCellVec = cellVec;
			}
		}
	}

	// find closest dis to cell edge
	minDis = 10;
	UNITY_UNROLL
	for (int y = -1; y <= 1; ++y)
	{
		UNITY_UNROLL
		for (int x = -1; x <= 1; ++x)
		{
			int idx = (y + 1) * 3 + (x + 1);
			float2 curGrid = grid + float2(x, y);

			float2 gridCenter = curGrid + noiseCache[idx];
			float2 cellToCenter = gridCenter - closestCell;
			float cellDis = length(cellToCenter);
			cellToCenter = normalize(cellToCenter);
			float curCellDis = dot(normalize(cellToCenter), closestCellVec);
			float disToEdge = cellDis / 2 - curCellDis;

			minDis = min(minDis, disToEdge);
		}
	}

	return minDis;
}
inline float2 voronoiNoiseInv22 (float2 uv, int2 gridCount, float seed = 0)
{
	return float2(
		voronoiNoiseInv21(uv, gridCount, seed + 0.0),
		voronoiNoiseInv21(uv, gridCount, seed + 0.1)
		);
}
inline float3 voronoiNoiseInv23 (float2 uv, int2 gridCount, float seed = 0)
{
	return float3(
		voronoiNoiseInv21(uv, gridCount, seed + 0.0),
		voronoiNoiseInv21(uv, gridCount, seed + 0.1),
		voronoiNoiseInv21(uv, gridCount, seed + 0.2)
		);
}
inline float4 voronoiNoiseInv24 (float2 uv, int2 gridCount, float seed = 0)
{
	return float4(
		voronoiNoiseInv21(uv, gridCount, seed + 0.0),
		voronoiNoiseInv21(uv, gridCount, seed + 0.1),
		voronoiNoiseInv21(uv, gridCount, seed + 0.2),
		voronoiNoiseInv21(uv, gridCount, seed + 0.3)
		);
}

// 3D voronoi noise inverse(distance to cell edge)
float voronoiNoiseInv31 (float3 uv, int3 gridCount, float seed = 0)
{
	// uv to grid space
	uv *= gridCount;
	float3 grid = floor(uv);

	// cache noise
	float3 noiseCache[27];
	UNITY_UNROLL
	for (int z = -1; z <= 1; ++z)
	{
		UNITY_UNROLL
		for (int y = -1; y <= 1; ++y)
		{
			UNITY_UNROLL
			for (int x = -1; x <= 1; ++x)
			{
				int idx = (z + 1) * 9 + (y + 1) * 3 + (x + 1);
				float3 curGrid = grid + float3(x, y, z);
				float3 repeatGrid = (curGrid + gridCount) % gridCount;
				noiseCache[idx] = goldNoise33(repeatGrid + 0.1f, seed);
			}
		}
	}

	// find closest grid center 
	float minDis = 10;
	float3 closestCell;
	float3 closestCellVec;
	UNITY_UNROLL
	for (int z = -1; z <= 1; ++z)
	{
		UNITY_UNROLL
		for (int y = -1; y <= 1; ++y)
		{
			UNITY_UNROLL
			for (int x = -1; x <= 1; ++x)
			{
				int idx = (z + 1) * 9 + (y + 1) * 3 + (x + 1);
				float3 curGrid = grid + float3(x, y, z);

				float3 gridCenter = curGrid + noiseCache[idx];
				float3 cellVec = uv - gridCenter;
				float curDis = length(cellVec);

				if (curDis < minDis)
				{
					minDis = curDis;
					closestCell = gridCenter;
					closestCellVec = cellVec;
				}
			}
		}
	}

	// find closest dis to cell edge
	minDis = 10;
	UNITY_UNROLL
	for (int z = -1; z <= 1; ++z)
	{
		UNITY_UNROLL
		for (int y = -1; y <= 1; ++y)
		{
			UNITY_UNROLL
			for (int x = -1; x <= 1; ++x)
			{
				int idx = (z + 1) * 9 + (y + 1) * 3 + (x + 1);
				float3 curGrid = grid + float3(x, y, z);

				float3 gridCenter = curGrid + noiseCache[idx];
				float3 cellToCenter = gridCenter - closestCell;
				float cellDis = length(cellToCenter);
				cellToCenter = normalize(cellToCenter);
				float curCellDis = dot(normalize(cellToCenter), closestCellVec);
				float disToEdge = cellDis / 2 - curCellDis;

				minDis = min(minDis, disToEdge);
			}
		}
	}

	return minDis;
}
inline float2 voronoiNoiseInv32 (float3 uv, int3 gridCount, float seed = 0)
{
	return float2(
		voronoiNoiseInv31(uv, gridCount, seed + 0.0),
		voronoiNoiseInv31(uv, gridCount, seed + 0.1)
		);
}
inline float3 voronoiNoiseInv33 (float3 uv, int3 gridCount, float seed = 0)
{
	return float3(
		voronoiNoiseInv31(uv, gridCount, seed + 0.0),
		voronoiNoiseInv31(uv, gridCount, seed + 0.1),
		voronoiNoiseInv31(uv, gridCount, seed + 0.2)
		);
}
inline float4 voronoiNoiseInv34 (float3 uv, int3 gridCount, float seed = 0)
{
	return float4(
		voronoiNoiseInv31(uv, gridCount, seed + 0.0),
		voronoiNoiseInv31(uv, gridCount, seed + 0.1),
		voronoiNoiseInv31(uv, gridCount, seed + 0.2),
		voronoiNoiseInv31(uv, gridCount, seed + 0.3)
		);
}

#endif

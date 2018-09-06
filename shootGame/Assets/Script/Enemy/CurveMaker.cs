using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CurveMaker
{
	private const int DEFAULT_LENGTH = 200;
	private List<Vector3> _resultPoints = null;

	private int _length = DEFAULT_LENGTH;

	public CurveMaker(List<Vector3> points, int length = DEFAULT_LENGTH)
	{
		_length = length;
		_resultPoints = MakeResultPoints (points, length);
	}

	//0-1
	public Vector3 GetPoint(float index)
	{
		int pointIndex = (int)(index * _length);
		return _resultPoints [pointIndex];
	}

	public List<Vector3> GetPointList()
	{
		return _resultPoints;
	}
		
	public int length
	{ get { return _length; } }

	private List<Vector3> MakeResultPoints(List<Vector3> points, int length = DEFAULT_LENGTH)
	{
		if (points.Count > 5)
			return null;
		if (points.Count == 5)
			return Make5Point (points, length);
		if (points.Count == 4)
			return Make4Point (points, length);
		if (points.Count == 3)
			return Make3Point (points, length);

		return null;
	}

	private List<Vector3> Make5Point(List<Vector3> points, int length = DEFAULT_LENGTH)
	{
		_resultPoints = new List<Vector3>();
		for (int i = 0; i < length; i++) 
		{
			float lerpValue = i / (float)length;
			Vector3 pos1 = Vector3.Lerp(points[0], points[1], lerpValue);
			Vector3 pos2 = Vector3.Lerp(points[1], points[2], lerpValue);
			Vector3 pos3 = Vector3.Lerp(points[2], points[3], lerpValue);
			Vector3 pos4 = Vector3.Lerp(points[3], points[4], lerpValue);

			Vector3 pos1_0 = Vector3.Lerp(pos1, pos2, lerpValue);
			Vector3 pos1_1 = Vector3.Lerp(pos2, pos3, lerpValue);
			Vector3 pos1_2 = Vector3.Lerp(pos3, pos4, lerpValue);

			Vector3 pos2_0 = Vector3.Lerp(pos1_0, pos1_1, lerpValue); 
			Vector3 pos2_1 = Vector3.Lerp(pos1_1, pos1_2, lerpValue); 

			Vector3 find = Vector3.Lerp(pos2_0, pos2_1, lerpValue);

			_resultPoints.Add(find);
		}
		return _resultPoints;
	}

	private List<Vector3> Make4Point(List<Vector3> points, int length = DEFAULT_LENGTH)
	{
		_resultPoints = new List<Vector3>();
		for (int i = 0; i < length; i++) 
		{
			float lerpValue = i / (float)length;
			Vector3 pos1 = Vector3.Lerp(points[0], points[1], lerpValue);  
			Vector3 pos2 = Vector3.Lerp(points[1], points[2], lerpValue);  
			Vector3 pos3 = Vector3.Lerp(points[2], points[3], lerpValue);  

			Vector3 pos1_0 = Vector3.Lerp(pos1, pos2, lerpValue);  
			Vector3 pos1_1 = Vector3.Lerp(pos2, pos3, lerpValue);  

			Vector3 find = Vector3.Lerp(pos1_0, pos1_1, lerpValue);  

			_resultPoints.Add(find);
		}
		return _resultPoints;
	}

	private List<Vector3> Make3Point(List<Vector3> points, int length = DEFAULT_LENGTH)
	{
		_resultPoints = new List<Vector3>();
		for (int i = 0; i < length; i++) 
		{
			float lerpValue = i / (float)length;
			Vector3 pos1 = Vector3.Lerp(points[0], points[1], lerpValue);  
			Vector3 pos2 = Vector3.Lerp(points[1], points[2], lerpValue);   

			Vector3 find = Vector3.Lerp(pos1, pos2, lerpValue);  

			_resultPoints.Add(find);
		}
		return _resultPoints;
	}

}

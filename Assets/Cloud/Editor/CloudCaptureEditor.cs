using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(CloudCapture))]
public class CloudCaptureEditor : Editor
{
	public override void OnInspectorGUI()
	{
		base.OnInspectorGUI();

		if (GUILayout.Button("print path"))
		{
			Object[] arr = Selection.GetFiltered(typeof(UnityEngine.Object), SelectionMode.TopLevel);
			string path = AssetDatabase.GetAssetPath(arr[0]);
			Debug.Log(path);
		}
	}
}
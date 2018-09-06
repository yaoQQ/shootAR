using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.iOS;

public class UnityARCameraManager1 : MonoBehaviour
{

    public Camera m_camera;
    private UnityARSessionNativeInterface m_session;
    private Material savedClearMaterial;

    [Header("AR Config Options")]
    public UnityARAlignment startAlignment = UnityARAlignment.UnityARAlignmentGravity;
    public UnityARPlaneDetection planeDetection = UnityARPlaneDetection.Horizontal;
    public bool getPointCloud = true;
    public bool enableLightEstimation = true;

    // Use this for initialization
    void Start()
    {

        m_session = UnityARSessionNativeInterface.GetARSessionNativeInterface();
      //  UnityARSessionNativeInterface.ARSessionTrackingChangedEvent += ARSessionTrackingChangedEvent;
#if !UNITY_EDITOR
		Application.targetFrameRate = 60;
        ARKitWorldTrackingSessionConfiguration config = new ARKitWorldTrackingSessionConfiguration();
		config.planeDetection = planeDetection;
		config.alignment = startAlignment;
		config.getPointCloudData = getPointCloud;
		config.enableLightEstimation = enableLightEstimation;
        m_session.RunWithConfig(config);

		if (m_camera == null) {
			m_camera = Camera.main;
		}
        pauseScan(true);
#else
        //put some defaults so that it doesnt complain
        UnityARCamera scamera = new UnityARCamera();
        scamera.worldTransform = new UnityARMatrix4x4(new Vector4(1, 0, 0, 0), new Vector4(0, 1, 0, 0), new Vector4(0, 0, 1, 0), new Vector4(0, 0, 0, 1));
        Matrix4x4 projMat = Matrix4x4.Perspective(60.0f, 1.33f, 0.1f, 30.0f);
        scamera.projectionMatrix = new UnityARMatrix4x4(projMat.GetColumn(0), projMat.GetColumn(1), projMat.GetColumn(2), projMat.GetColumn(3));

        UnityARSessionNativeInterface.SetStaticCamera(scamera);

#endif
    }
    public void pauseScan(bool isPause)
    {
        UnityARPlaneDetection dir = isPause ? UnityARPlaneDetection.None : UnityARPlaneDetection.Horizontal;
        ARKitWorldTrackingSessionConfiguration sessionConfig = new ARKitWorldTrackingSessionConfiguration(UnityARAlignment.UnityARAlignmentGravity, dir);
        if (!isPause)
        {
            sessionConfig.alignment = UnityARAlignment.UnityARAlignmentGravity;
            sessionConfig.getPointCloudData = getPointCloud;
            sessionConfig.enableLightEstimation = enableLightEstimation;
        }
        UnityARSessionNativeInterface.GetARSessionNativeInterface().RunWithConfigAndOptions(sessionConfig, 0);
    }
    public void SetCamera(Camera newCamera)
    {
        if (m_camera != null)
        {
            UnityARVideo oldARVideo = m_camera.gameObject.GetComponent<UnityARVideo>();
            if (oldARVideo != null)
            {
                savedClearMaterial = oldARVideo.m_ClearMaterial;
                Destroy(oldARVideo);
            }
        }
        SetupNewCamera(newCamera);
    }

    private void SetupNewCamera(Camera newCamera)
    {
        m_camera = newCamera;

        if (m_camera != null)
        {
            UnityARVideo unityARVideo = m_camera.gameObject.GetComponent<UnityARVideo>();
            if (unityARVideo != null)
            {
                savedClearMaterial = unityARVideo.m_ClearMaterial;
                Destroy(unityARVideo);
            }
            unityARVideo = m_camera.gameObject.AddComponent<UnityARVideo>();
            unityARVideo.m_ClearMaterial = savedClearMaterial;
        }
    }

    // Update is called once per frame

    void Update()
    {

        if (m_camera != null)
        {
            // JUST WORKS!
            Matrix4x4 matrix = m_session.GetCameraPose();


            m_camera.transform.localRotation = UnityARMatrixOps.GetRotation(matrix);
            m_camera.projectionMatrix = m_session.GetCameraProjection();
        }

    }
    private bool isMove = false;
    public void LateUpdate()
    {
        Matrix4x4 matrix = m_session.GetCameraPose();
        Vector3 pos = UnityARMatrixOps.GetPosition(matrix);
        if (Vector3.Distance(m_camera.transform.localPosition, pos) <= 0.01f* UnityARMatrixOps.ARworldSize)
        {
            isMove = false;
        }
        if (Vector3.Distance(m_camera.transform.localPosition, pos) > 0.02f * UnityARMatrixOps.ARworldSize)
        {
            isMove = true;
        }
        if (isMove)
        {
            Vector3 theResultPos = Vector3.Lerp(m_camera.transform.localPosition, pos, Time.deltaTime * 6* UnityARMatrixOps.ARworldSize);
            m_camera.transform.localPosition = theResultPos;

        }

    }

    private bool isShowRest = false;
    void OnGUI()
    {


        //if (GUI.Button(new Rect(0, 150, 280, 40), "20UnityARMatrixOps.ARworldSize+5="+ UnityARMatrixOps.ARworldSize))
        //{
         //   UnityARMatrixOps.ARworldSize += 1;

        //    if (UnityARMatrixOps.ARworldSize > 20)
        //    {
        //        UnityARMatrixOps.ARworldSize = 0;
        //    }
        //}

        //if (GUI.Button(new Rect(0, 250, 280, 40), "100UnityARMatrixOps.ARworldSize+10=" + UnityARMatrixOps.ARworldSize))
        //{
        //    UnityARMatrixOps.ARworldSize += 10;

        //    if (UnityARMatrixOps.ARworldSize > 100)
        //    {
        //        UnityARMatrixOps.ARworldSize = 0;
        //    }
        //}
        //if(GUI.Button(new Rect(270, 290, 200, 80), "index=" + index))
        //{
        //    restTracking(index);
        //    index++;
        //    if (index > 3)
        //    {
        //        index = 0;
        //    }
        //}
        //if (GUI.Button(new Rect(270, 210, 200, 80), "puase" ))
        //{
        //    UnityARSessionNativeInterface.GetARSessionNativeInterface().Pause();
        //}
    }
    private int index = 0;
    UnityARSessionRunOption[] runOptions = new UnityARSessionRunOption[4];
    public void restTracking(int currIndex)
    {
        if (!isShowRest)
        {
            return;
        }
        runOptions[0] = UnityARSessionRunOption.ARSessionRunOptionRemoveExistingAnchors | UnityARSessionRunOption.ARSessionRunOptionResetTracking;
        runOptions[1] = UnityARSessionRunOption.ARSessionRunOptionResetTracking;
        runOptions[2] = UnityARSessionRunOption.ARSessionRunOptionRemoveExistingAnchors;
        runOptions[3] = 0;
        bool isPause = true;
        index = currIndex;
        UnityARPlaneDetection dir = isPause ? UnityARPlaneDetection.None : UnityARPlaneDetection.Horizontal;
        ARKitWorldTrackingSessionConfiguration sessionConfig = new ARKitWorldTrackingSessionConfiguration(UnityARAlignment.UnityARAlignmentGravity, dir);
        if (!isPause)
        {
            sessionConfig.alignment = UnityARAlignment.UnityARAlignmentGravity;
            sessionConfig.getPointCloudData = false;
            sessionConfig.enableLightEstimation = false;
        }
        UnityARSessionNativeInterface.GetARSessionNativeInterface().RunWithConfigAndOptions(sessionConfig, runOptions[index]);
       // Debug.Log("restTracking[" + index + "]=" + runOptions[index].ToString());
    }
    private void ARSessionTrackingChangedEvent(UnityARCamera camera)
    {
        //变化好的话 重置扫描
        //Debug.Log("ARSessionTrackingChangedEvent()");
        //Debug.Log("camera.trackingStat=" + camera.trackingState);
        //Debug.Log("camera.trackingReason=" + camera.trackingReason);
        string str = camera.trackingState.ToString() + ":";

        switch (camera.trackingState)
        {
            case ARTrackingState.ARTrackingStateNotAvailable:
                str += "跟踪不到平面";
                restTracking(2);
                break;
            case ARTrackingState.ARTrackingStateLimited:
                str += "跟踪受限，跟踪不够完整:";
                break;
            case ARTrackingState.ARTrackingStateNormal:
                str += "正常跟踪";
                restTracking(2);
                break;
        }
        str += ARTrackingStateLimited(camera);
      //  Debug.Log(str);
    }


    private string ARTrackingStateLimited(UnityARCamera camera)
    {

        string str = "  " + camera.trackingReason.ToString() + ":";
        switch (camera.trackingReason)
        {
            case ARTrackingStateReason.ARTrackingStateReasonNone:
                str += "正常的，没有任何原因导致";
                break;
            case ARTrackingStateReason.ARTrackingStateReasonInitializing:
                str += "初始化未完成";
                break;
            case ARTrackingStateReason.ARTrackingStateReasonExcessiveMotion:
                str += "手抖动的太厉害，无法追踪到东西";
                //  UnityARSessionNativeInterface.GetARSessionNativeInterface().Pause();
                restTracking(2);
                break;
            case ARTrackingStateReason.ARTrackingStateReasonInsufficientFeatures:
                str += "跟踪识别的平面是苍白的主体，没有放置或分辨任何东西，无法识别平面";
                restTracking(2);
                break;
        }
        return str;
    }
}

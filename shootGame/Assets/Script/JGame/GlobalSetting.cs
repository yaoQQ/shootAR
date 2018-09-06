using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GlobalSetting
{
    public static bool IS_SHOW_SKYBOX = true;

    public static Camera mainCamera = null;
    public static void UpdateSkybox()
    {
        if (mainCamera == null) return;
        if (GlobalSetting.IS_SHOW_SKYBOX)
        {
            mainCamera.clearFlags = CameraClearFlags.Skybox;
        }
        else
        {
            mainCamera.clearFlags = CameraClearFlags.Nothing;
        }
    }
}


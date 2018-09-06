using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FightLogic : MonoBehaviour
{
    public Camera mainCamera;

    public void Start()
    {
        GlobalSetting.mainCamera = mainCamera;
        GlobalSetting.UpdateSkybox();

        LevelManager.Instanse.Init();
        JShipManager.Instanse.Init();
    }

    void Update()
    {
        
    }

    void FixedUpdate()
    {
        float timePass = Time.fixedDeltaTime;
        LevelManager.Instanse.UpdateLogic(timePass);
        JShipManager.Instanse.UpdateLogic(timePass);
    }

}

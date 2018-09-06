using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class EnemyDefend : ColliderItem
{
    public ShipBase mainDend;
    public List<ShipBase> defendItem;

    //对象池重新获取激活调用
    public override void Active()
    {
        mainDend.gameObject.SetActive(true);
        mainDend.Active();
        for (int i = 0; i < defendItem.Count; i++)
        {
            defendItem[i].gameObject.SetActive(true);
            defendItem[i].Active();
        }
    }
    public void Start()
    {
        if (defendItem == null) return;
        for(int i=0;i< defendItem.Count; i++)
        {
            defendItem[i].DeadCallBackFun = itemDestroy;
        }
        mainDend.DeadCallBackFun = itemDestroy;
    }

    public void Update()
    {

    }
    private void itemDestroy()
    {
        if (mainDend.life <= 0)
        {
            closeDefend();
            return;
        }
        bool isAllDestroy = true;
        for (int i = 0; i < defendItem.Count; i++)
        {
            if (defendItem[i].gameObject.activeSelf == true)
            {
                isAllDestroy = false;
                break;
            }
        }
        if (isAllDestroy)
        {
            closeDefend();
        }
    }
    private void closeDefend()
    {
        mainDend.gameObject.SetActive(false);
    }
}


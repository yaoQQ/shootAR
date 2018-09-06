using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;


//瞄准器脚本
public class TargetLog : MonoBehaviour
{


    public float scaleSpeed = 0.008f;//逐渐减小速度


    public void Update()
    {
        if (this.transform.localScale.x > 1)
        {
            this.transform.localScale = Vector3.one * (this.transform.localScale.x - scaleSpeed);
            //  Debug.Log("update TargetLog=" + this.transform.localScale);
            if (this.transform.localScale.x > 1.3f)
            {
                this.transform.localScale = Vector3.one * 1.3f;
            }
        }
        else if (this.transform.localScale.x < 1)
        {
            this.transform.localScale = Vector3.one;
        }
    }
    //不断增大
    public void shoot()
    {
        this.transform.localScale = Vector3.one * (this.transform.localScale.x + 0.025f);
    }

}


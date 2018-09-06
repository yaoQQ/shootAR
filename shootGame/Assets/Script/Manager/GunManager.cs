using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

//设置玩家射击按钮，标志位
public enum PlayerGunBtnsEnum
{
    rightUp,
    rightDown,
    leftUp,
    leftDown,
    none
}

////设置枪的位置 左 右 中
//public enum PlayerGunPosEnum
//{
//    Left,
//    Right,
//    Middle,
//    None
//}

public enum GunType
{
    normalGun = 1,
    LightGun = 2,
    FastGun =3,
    DefendGun = 4,
    disturbGun =5,
    AOEGun=6,
    None =0
}
public class GunManager : Singleton<GunManager>
{
    public static GameObject Bullets;//搜集所有子弹父类，方便编辑器查看
    public static GameObject Ships;//搜集所有飞船父类，方便编辑器查看

    private Dictionary<PlayerGunBtnsEnum, GunBtn> gunBtnDic;//位置的按钮
 
    public void init()
    {
        //子弹容器
        Bullets = GameObject.Find("Bullets");
        if (Bullets == null)
        {
            Bullets = new GameObject("Bullets");
        }
        Ships = GameObject.Find("Ships");
        if (Ships == null)
        {
            Ships = new GameObject("Ships");
        }
        //槽位按钮
        gunBtnDic = new Dictionary<PlayerGunBtnsEnum, GunBtn>();
        GunBtn[] objs = GameObject.FindObjectsOfType(typeof(GunBtn)) as GunBtn[];
        for(int i=0;i< objs.Length; i++)
        {
            gunBtnDic[objs[i].btnPos] = objs[i];
        }
    }

    //设置武器按钮及初始化枪支
    public void setBtnGun(PlayerGunBtnsEnum btn,GunType type)
    {
        gunBtnDic[btn].gunType = type;
    }
    //根据位置获取按钮槽位
    public GunBtn getGunBtnByType(PlayerGunBtnsEnum btn)
    {
        if (!gunBtnDic.ContainsKey(btn))
        {
            return null;
        }
  
        return gunBtnDic[btn];
    }



    ////更新枪的位置
    //public void updateGunPos(PlayerGun gun, PlayerGunPosEnum pos)
    //{
    //    PlayerGunPos gunPosObj = GunManager.Instance.getGunPos(pos);
    //    if (gunPosObj != null)
    //    {
    //        gun.transform.parent = gunPosObj.transform;
    //        gun.transform.localPosition = Vector3.zero;
    //    }
    //}
}


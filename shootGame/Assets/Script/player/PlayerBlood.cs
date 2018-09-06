using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;

public enum farward
{
    left,
    right,
    down,
    up,

    none
}

public class PlayerBlood : MonoBehaviour
{
    private Image blood;
    private Text bloodText;
    private float _bloodValue = 100;
    private float _totalVaue = 100;
    private BloodDamage bloodDamaget;

    void Awake()
    {
        blood = this.transform.Find("blood").GetComponent<Image>();
        bloodText = this.transform.Find("bloodText").GetComponent<Text>();
        bloodDamaget = this.transform.Find("BloodLog").GetComponent<BloodDamage>();
    }
    void Start()
    {
       
    }
    private float setBloodValue
    {
        set
        {
            _bloodValue = value;
            updateView(_bloodValue / _totalVaue);
        }
        get
        {
            return _bloodValue;
        }

    }
    //收到打击
    public float damage(float damageValue,GameObject hitTarget)
    {
        // Debug.Log("damageValue="+ damageValue);
        _bloodValue -= damageValue;
        setBloodValue = _bloodValue;
        if (setBloodValue < 0)
        {
            setBloodValue = 0;
        }
        StartCoroutine(showDamageEffect(blood));
        StartCoroutine(damageFard(hitTarget));
        return setBloodValue;
    }



    IEnumerator showDamageEffect(Image img,bool isHide=false)
    {
        float time = 0.2f;
        img.CrossFadeAlpha(0, time, true);
        yield return new WaitForSeconds(time);
        img.CrossFadeAlpha(1, time, true);
        yield return new WaitForSeconds(time);
        img.CrossFadeAlpha(0, time, true);
        yield return new WaitForSeconds(time);
        img.CrossFadeAlpha(1, time, true);
        yield return new WaitForSeconds(time);
        if (isHide)
        {
            img.gameObject.SetActive(false);
        }
    }
    IEnumerator  damageFard(GameObject hitTarget)
    {

        farward fa = worldPosToMap2(hitTarget);
        if(fa == farward.none)
        {
          yield return null;
        }
        Image img = bloodDamaget.damageFard(fa);
        // StartCoroutine(showDamageEffect(img,true));
        img.color= new Color(img.color.b, img.color.g, img.color.r,1);
        img.gameObject.SetActive(true);
        img.CrossFadeAlpha(0, 2, true);
        yield return new WaitForSeconds(2);
        img.gameObject.SetActive(false);
    }
  
    private farward worldPosToMap2(GameObject enemyStruct)
    {
        GameObject obj = enemyStruct;
        if (obj == null)
            return farward.none;
        Vector3 pos = obj.transform.position;
        Vector3 targetPos = CameraManager.Instance.Player.position;
        float angel = MyUtils.Angle(targetPos, CameraManager.Instance.MainCamera.transform.forward, obj.transform.position);
        if (angel >= 0 && angel <= 35)
        {
            return farward.up;
        }
        if (angel >= 145 && angel <= 180)
        {
            return farward.down;
        }


        Vector3 left = CameraManager.Instance.MainCamera.transform.TransformDirection(Vector3.right);
        Vector3 toOtherL = pos - targetPos;
        if (Vector3.Dot(left, toOtherL) < 0)
        {
            return farward.left;
        }
        else
        {
            return farward.right;
        }
        return farward.none;
    }
   
    private void ColorUpdate(float value)
    {
        blood.color= new Color(blood.color.r, blood.color.g, blood.color.b, value);
    }
    private void updateView(float percentValue)
    {
        blood.rectTransform.sizeDelta = new Vector2(percentValue * 250, 30);
        bloodText.text = (int)(_bloodValue) + "/"+ _totalVaue;
    }
    public float totalVaue
    {
        set
        {
            _totalVaue = value;
        }
    }
}


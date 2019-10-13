using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Powerpee : MonoBehaviour
{
    public GameObject ball;
    public int speed;
    public GameObject powerpee;
    // Update is called once per frame

    void Update()
    {
        StartCoroutine(Attackpee());
    }

    IEnumerator Attackpee ()
    {
        var bullet = Instantiate(ball, transform.position, transform.rotation);
        bullet.GetComponent<Rigidbody>().velocity = bullet.transform.forward * speed;
        yield return new WaitForSeconds(5);
        powerpee.SetActive(false);
    }

}
